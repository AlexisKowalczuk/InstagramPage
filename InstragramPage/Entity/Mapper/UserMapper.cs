using DapperExtensions.Mapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InstagramPage.Entity
{
  public class UserMapper : ClassMapper<User>
  {
    public UserMapper()
    {
      Table("User");
      Map(x => x.Id).Column(nameof(User.Id)).Key(KeyType.Identity);
      Map(x => x.Name).Column(nameof(User.Name));
      Map(x => x.Description).Column(nameof(User.Description));
    }
  }
}
