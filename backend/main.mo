import Nat "mo:base/Nat";

import Int "mo:base/Int";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Order "mo:base/Order";

actor {
  type Post = {
    id: Nat;
    title: Text;
    body: Text;
    author: Text;
    timestamp: Int;
  };

  stable var nextPostId: Nat = 0;
  let posts = Buffer.Buffer<Post>(0);

  public func createPost(title: Text, body: Text, author: Text) : async Result.Result<Nat, Text> {
    let post : Post = {
      id = nextPostId;
      title = title;
      body = body;
      author = author;
      timestamp = Time.now();
    };
    posts.add(post);
    nextPostId += 1;
    #ok(post.id)
  };

  public query func getPosts() : async [Post] {
    let sortedPosts = Buffer.toArray(posts);
    Array.sort(sortedPosts, func(a: Post, b: Post) : Order.Order {
      if (a.timestamp > b.timestamp) { #less }
      else if (a.timestamp < b.timestamp) { #greater }
      else { #equal }
    })
  };
}
