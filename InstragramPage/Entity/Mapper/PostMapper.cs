using DapperExtensions.Mapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InstagramPage.Entity
{
  public class PostMapper : ClassMapper<Post>
  {
    public PostMapper()
    {
      Table("Post");
      Map(x => x.Id).Column(nameof(Post.Id)).Key(KeyType.Identity);
      Map(x => x.Creator).Column(nameof(Post.Creator));
      Map(x => x.CreatedAt).Column(nameof(Post.CreatedAt));
      Map(x => x.Description).Column(nameof(Post.Description));
    }
  }
}
