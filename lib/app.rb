require 'idea_box'
require './lib/idea_box/image_uploader'
require 'pry'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'
  get('/styles.css') { scss :styles }

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  get '/idea' do
    erb :idea
  end

  get '/existing' do
    erb :existing, locals: {ideas: IdeaStore.all.sort}
  end

  post '/' do
    uploader = ImageUploader.new
    uploader.store!(params['idea']['image'])
    params['idea']['images']          = params['idea']['image'][:filename]
    params[:idea]['images']           = params['idea']['image'][:filename]
    params_without_image              = params['idea'].delete('image')
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/existing'
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
    redirect '/existing'
  end

  post '/:id/dislike' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.dislike!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/existing'
  end

  get '/:tag' do |tag|
    ideas = IdeaStore.find_tags(tag)
    # binding.pry
    erb :tags, locals: {:tag => tag, :ideas => ideas}

  end

  get '/:id/details' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :details, locals: {:idea => idea}
  end
end
