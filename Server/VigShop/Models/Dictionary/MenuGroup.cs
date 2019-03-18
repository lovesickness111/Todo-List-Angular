using Models.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models.Dictionary
{
    public class MenuGroup:Entity<Guid>
    {
        public Guid groupID { get; set; }
        public string groupCode { get; set; }
        public string groupName { get; set; }
        public string groupDescription { get; set; }
        public int typeID { get; set; }
        public string typeName { get; set; }
        public Guid restaurantID { get; set; }
        public string restaurantName { get; set; }
        public bool groupUnfollow { get; set; }
    }
}