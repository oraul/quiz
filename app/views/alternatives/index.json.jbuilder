# frozen_string_literal: true

json.array! @alternatives, partial: 'alternatives/alternative', as: :alternative
