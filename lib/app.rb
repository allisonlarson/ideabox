require 'idea_box'
require './lib/idea_box/image_uploader'
require 'pry'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'
  get('/styles.css') { scss :styles }
  get('/uploads') { }

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  get '/idea' do
    erb :idea
  end

  post '/' do
    uploader = ImageUploader.new
    uploader.store!(params['idea']['image'])
    uploader.store!(params['idea']['resource_image'])
    params['idea']['images'] = params['idea']['image'][:filename]
    params['idea']['resource_images'] = params['idea']['resource_image'][:filename]
    params_without_image = params['idea'].delete('image') && params['idea'].delete('resource_image')
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/:tag' do |tag|
    ideas = IdeaStore.find_tags(tag)
    erb :tags, locals: {:tag => tag, :ideas => ideas}

  end

  get '/:id/details' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :details, locals: {:idea => idea}
  end
end
