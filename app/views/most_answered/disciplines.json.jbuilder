# frozen_string_literal: true

json.array! @disciplines, partial: 'most_answered/discipline', as: :discipline
