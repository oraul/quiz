# frozen_string_literal: true

UserEntity = Struct.new(:sub, :name, :exp, :iss, :aud, keyword_init: true)
