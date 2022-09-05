using InstagramPage.Entity;
using System.Collections.Generic;

namespace InstagramPage.Data
{
	public interface IInstagramManagement
	{
		IList<User> GetFollowers(string user);

		IList<User> GetFollows(string user);

		IList<FeedItem> GetFeed(string user);

		IList<Post> GetPostLiked(string user);

		void Like(string postId, string user);

		void Dislike(string postId, string user);

		IList<string> GetHashtags(string postId);
	}
}