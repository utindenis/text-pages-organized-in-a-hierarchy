# frozen_string_literal: true

json.extract! category, :id, :parent_id, :title, :alias, :url, :text, :text_html, :created_at, :updated_at
json.url category_url(category, format: :json)
