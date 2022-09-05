using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InstagramPage.Entity
{
	public class FeedItem
	{
		public string Id { get; set; }
		
		public string Creator { get; set; }
		public string Description { get; set; }

		
		public int Likes { get; set; }

		public bool UserLike { get; set; }
	}
}
