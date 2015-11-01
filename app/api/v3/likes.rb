module V3
  class Likes < Grape::API
    resource :likes do
      desc %(赞
这是一个多态的接口，支持赞 `topic` 和 `reply`，你可以将赞的函数设计成和 API 一样

例如：

```ruby
# 赞编号为 1234 的话题
Faraday.post("/api/v3/likes.json", { obj_type: "topic", obj_id: 1234 })
```
      )
      params do
        requires :obj_type, type: String, values: %w(topic reply)
        requires :obj_id, type: Integer
      end
      post '' do
        doorkeeper_authorize!
        if params[:obj_type] == 'topic'
          obj = Topic.find(params[:obj_id])
        else
          obj = Reply.find(params[:obj_id])
        end

        current_user.like(obj)
        { obj_type: params[:obj_type], obj_id: obj.id, count: obj.likes_count }
      end

      desc '取消之前的赞'
      params do
        requires :obj_type, type: String, values: %w(topic reply)
        requires :obj_id, type: Integer
      end
      delete '' do
        doorkeeper_authorize!
        if params[:obj_type] == 'topic'
          obj = Topic.find(params[:obj_id])
        else
          obj = Reply.find(params[:obj_id])
        end

        current_user.unlike(obj)
        { obj_type: params[:obj_type], obj_id: obj.id, count: obj.likes_count }
      end
    end
  end
end
