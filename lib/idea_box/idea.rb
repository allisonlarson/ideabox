class Idea
  include Comparable
  attr_reader :title,
              :description,
              :rank,
              :id,
              :tags,
              :resource1,
              :resource2,
              :resource3

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @id          = attributes["id"]
    @tags        = parse_tags(attributes["tags"])
    @resource1   = attributes["resource1"]
    @resource2   = attributes["resource2"]
    @resource3   = attributes["resource3"]
  end

  def save
    IdeaStore.create(to_h)
  end

  def parse_tags(tag)
    tag.split(',') unless tag.nil?
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "tags" => tags,
      "resource" => resource
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end
