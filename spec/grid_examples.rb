# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

class Header < Hashcraft::Base
  option :title, eager: true, default: 'Untitled Grid'

  option :message
end

class Content < Hashcraft::Base
  option :property
end

class Column < Hashcraft::Base
  option :header, :property

  option :context, mutator: :hash

  option :content, craft: Content,
                   mutator: :array,
                   key: :contents
end

class Grid < Hashcraft::Base
  option :api_url,
         :name

  option :child, key: :children,
                 mutator: :array

  option :context, mutator: :hash

  option :header, craft: Header

  option :max_width, eager: true,
                     default: '350px'

  option :column, craft: Column,
                  mutator: :array,
                  key: :columns
end
