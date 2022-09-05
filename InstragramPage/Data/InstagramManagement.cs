using Dapper;
using Endor.DataAccess.Factory;
using InstagramPage.Entity;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InstagramPage.Data
{
	public class InstagramManagement : IInstagramManagement
	{
		ILogger<InstagramManagement> log;

		private IDataAccessRegistry dataAccessRegistry;

		public InstagramManagement(ILogger<InstagramManagement> _log, IDataAccessRegistry _dataAccessRegistry)
		{
			log = _log;
			dataAccessRegistry = _dataAccessRegistry;
		}

		public IList<User> GetFollowers(string user)
		{
			List<User> list;
			var da = dataAccessRegistry.GetDataAccess();
			using (var cnn = da.GetProvider().GetDbConnection())
			{
				var sql = @$"
									SELECT follower.Id, follower.Name, follower.Description
									FROM [User] usr, Followers, [User] follower
									WHERE 
										MATCH(usr-(Followers)->follower)
										AND usr.Id = '{user}';";

				list = cnn.QueryAsync<User>(sql).ConfigureAwait(false).GetAwaiter().GetResult().ToList();
			}

			return list;
		}

		public IList<User> GetFollows(string user)
		{
			List<User> list;
			var da = dataAccessRegistry.GetDataAccess();
			using (var cnn = da.GetProvider().GetDbConnection())
			{
				var sql = @$"
									SELECT follower.Id, follower.Name, follower.Description
									FROM [User] usr, Followers, [User] follower
									WHERE 
										MATCH(follower-(Followers)->usr)
										AND usr.Id = '{user}';";

				list = cnn.QueryAsync<User>(sql).ConfigureAwait(false).GetAwaiter().GetResult().ToList();
			}

			return list;
		}

		//public IList<Post> GetFeed(string user)
		//{
		//	List<Post> list;
		//	var da = dataAccessRegistry.GetDataAccess();
		//	using (var cnn = da.GetProvider().GetDbConnection())
		//	{
		//		var sql = @$"
		//							SELECT Post.Id, Post.Creator, Post.Description, Post.CreatedAt FROM Post
		//							WHERE 
		//								Post.Creator in (
		//									SELECT follower.Id
		//										FROM [User] usr, Followers, [User] follower
		//										WHERE 
		//											MATCH(usr-(Followers)->follower)
		//											AND usr.Id = '{user}'
		//								);";

		//		list = cnn.QueryAsync<Post>(sql).ConfigureAwait(false).GetAwaiter().GetResult().ToList();
		//	}

		//	return list;
		//}

		public IList<Post> GetPostLiked(string user)
		{
			List<Post> list;
			var da = dataAccessRegistry.GetDataAccess();
			using (var cnn = da.GetProvider().GetDbConnection())
			{
				var sql = @$"
									SELECT Post.Id, Post.Creator, Post.Description, Post.CreatedAt FROM Post, [User], PostLikes
									WHERE 
										MATCH([User]-(PostLikes)->Post)
										AND [User].Id = '{user}';";

				list = cnn.QueryAsync<Post>(sql).ConfigureAwait(false).GetAwaiter().GetResult().ToList();
			}

			return list;
		}

		public IList<FeedItem> GetFeed(string user)
		{
			List<FeedItem> list;
			var da = dataAccessRegistry.GetDataAccess();
			using (var cnn = da.GetProvider().GetDbConnection())
			{
				var sql = @$"
									SELECT  Feed.*, 
									CASE WHEN LikedPost.Id is not null THEN 1 ELSE 0 END AS UserLike
									 FROM 
										(
											SELECT Post.Id, Post.Creator, Post.Description, CASE WHEN PostLikes.Likes is not null THEN PostLikes.Likes ELSE 0 END AS Likes FROM 
											(
												SELECT Distinct Post.Id, Post.Creator, Post.Description FROM Post, [User], PostLikes
													WHERE 
													Post.Creator in (
														SELECT follower.Id
															FROM [User] usr, Followers, [User] follower
															WHERE 
																MATCH(usr-(Followers)->follower)
																AND usr.Id = '{user}'
													)
											) AS Post 
											LEFT JOIN (
												SELECT Post.Id, Count(*) Likes FROM Post, [User], PostLikes
												WHERE MATCH([User]-(PostLikes)->[Post])
												GROUP BY Post.Id
											) AS PostLikes ON PostLikes.Id = Post.Id
										) AS Feed
										LEFT JOIN (
										SELECT Post.Id, Post.Description FROM Post, [User], PostLikes
										WHERE 
											MATCH([User]-(PostLikes)->Post)
											AND [User].Id = '{user}'
										) AS LikedPost ON LikedPost.Id = Feed.Id
										";

				list = cnn.QueryAsync<FeedItem>(sql).ConfigureAwait(false).GetAwaiter().GetResult().ToList();
			}

			return list;
		}

		public void Like(string postId, string user)
		{

			var da = dataAccessRegistry.GetDataAccess();
			using (var cnn = da.GetProvider().GetDbConnection())
			{
				var sql = @$"
										INSERT INTO PostLikes VALUES 
											((SELECT $node_id FROM [User] WHERE ID = '{user}'), (SELECT $node_id FROM [Post] WHERE ID = {postId}));";
				cnn.ExecuteAsync(sql).ConfigureAwait(false).GetAwaiter().GetResult();
			}
		}

		public void Dislike(string postId, string user)
		{

			var da = dataAccessRegistry.GetDataAccess();
			using (var cnn = da.GetProvider().GetDbConnection())
			{
				var sql = @$"
										DELETE PostLikes
										FROM [User], PostLikes, [Post]
										WHERE MATCH([User]-(PostLikes)->[Post])
											AND [User].Id= '{user}'
											AND [Post].Id = {postId};
										";
					cnn.ExecuteAsync(sql).ConfigureAwait(false).GetAwaiter().GetResult();
			}
		}

		public IList<string> GetHashtags(string postId)
		{
			List<string> list;
			var da = dataAccessRegistry.GetDataAccess();
			using (var cnn = da.GetProvider().GetDbConnection())
			{
				var sql = @$"
									SELECT Hashtag.Name FROM Post, PostHashtags, Hashtag
									WHERE MATCH(Post-(PostHashtags)->Hashtag)
									AND Post.Id = '{postId}'
									";

				list = cnn.QueryAsync<string>(sql).ConfigureAwait(false).GetAwaiter().GetResult().ToList();
			}

			return list;
		}
	}
}
