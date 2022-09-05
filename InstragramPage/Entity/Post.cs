using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InstagramPage.Entity
{
	public class Post
	{
		public string Id { get; set; }
		public string Creator { get; set; }
		public string Description { get; set; }
		public DateTime CreatedAt { get; set; }

	}
}
