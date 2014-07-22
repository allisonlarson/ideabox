class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id, :tags

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @id          = attributes["id"]
    @tags        = parse_tags(attributes["tags"])
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
      "tags" => tags
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end
