class Idea
  include Comparable
  attr_reader :title,
              :description,
              :rank,
              :id,
              :tags,
              :images,
              :resource1,
              :resource3

  def initialize(attributes = {})
    @title            = attributes["title"]
    @description      = attributes["description"]
    @rank             = attributes["rank"] || 1
    @id               = attributes["id"]
    @tags             = parse_tags(attributes["tags"])
    @images           = attributes["images"]
    @resource1        = attributes["resource1"]
    @resource3        = attributes["resource3"]
  end

  def save
    IdeaStore.create(to_h)
  end

  def parse_tags(tag)
    if tag.class != Array
      tag.split(',') unless tag.nil?
    else
      tag
    end
  end

  def to_h
    {
      "title"          => title,
      "description"    => description,
      "rank"           => rank,
      "id"             => id,
      "tags"           => tags,
      "images"         => images,
      "resource1"      => resource1,
      "resource3"      => resource3
    }
  end

  def like!
    @rank += 1
  end

  def dislike!
    if @rank > 0
      @rank -= 1
    else
      @rank
    end
  end

  def <=>(other)
    other.rank <=> rank
  end
end
