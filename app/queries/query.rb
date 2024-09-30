class Query
  def self.call(scope, **args)
    new(scope).call(**args)
  end
end
