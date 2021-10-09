# frozen_string_literal: true

# Description/Explanation of Category class
class Category < ApplicationRecord
  validates :title,
            presence: true,
            length: { maximum: 255, too_long: '%{count} characters is the maximum allowed' }

  validates :alias,
            presence: true,
            length: { maximum: 255, too_long: '%{count} characters is the maximum allowed' },
            format: { with: /\A[\wа-яА-ЯёЁ_]*\z/i, message: 'only allows letters' }

  validate :check_action_in_alias
  validate :check_unique_alias

  def check_action_in_alias
    data = %w[index add create edit update delete]
    errors.add(:alias, "can't be the same words: #{data.join(', ')}") if data.include?(self[:alias])
  end

  def check_unique_alias
    cnt = Category.where(parent_id: self[:parent_id], alias: self[:alias]).count
    errors.add(:alias, 'already exists') if cnt.nonzero?
  end

  def text=(val)
    self[:text] = val
    self[:text_html] = HTMLEntities.new.encode(val)
                                   .gsub(/\r/, '')
                                   .gsub(/\n/, '<br>')
                                   .gsub(/\*{2}(.*?)\*{2}/) { "<b>#{Regexp.last_match(1)}</b>" }
                                   .gsub(/\\{2}(.*?)\\{2}/) { "<i>#{Regexp.last_match(1)}</i>" }
                                   .gsub(%r{\({2}(?:(?:https?:)?(?:/{2}[^/]+))?(/?.*?)\s+(.*?)\){2}}) { "<a href=\"#{Regexp.last_match(1)}\">#{Regexp.last_match(2)}</a>" }
  end

  def url(action = '')
    action = "/#{action}" if action.size.nonzero?
    result = (self[:url] || '') + action

    return '/' if result.size.zero?

    result
  end

  def add_url
    url('add')
  end

  def create_url
    url('create')
  end

  def edit_url
    url('edit')
  end

  def update_url
    url('update')
  end

  def delete_url
    url('delete')
  end

  def parent
    @parent ||= Category.find self[:parent_id] || Category.new
  end

  def parent=(parent)
    @parent = parent

    self[:parent_id] = parent.id || 0
    self[:url] = parent.url(self[:alias])
  end

  def parent_url
    return '/' if !parent_id || parent_id.zero?

    parent.url
  end

  def children
    Category.where(parent_id: self[:id]).all
  end

  def self.by_alias(link)
    link ||= ''
    link.gsub(%r{(^/*)|(/*$)}, '')

    return nil if link.size.zero?

    where(url: "/#{link}").first
  end

  def tree
    Category.tree(self[:id])
  end

  def self.tree(parent_id = 0, list = nil)
    result = []
    list ||= Category.all

    list.each do |item|
      result.push({ item: item, children: tree(item.id, list) }) if item.parent_id == parent_id
    end

    result
  end

  def destroy_tree
    id_list = [self[:id]]
    tree_array = tree

    while (elem = tree_array.pop)
      id_list.push(elem[:item].id)
      tree_array += elem[:children]
    end

    Category.where(id: id_list).destroy_all
  end
end
