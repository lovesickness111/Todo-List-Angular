using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace VigShop.Models
{
    public class menuGroup
    {
        public string typeName { get; set; }
        public Guid groupID { get; set; }
        public string groupCode { get; set; }
        public string groupName { get; set; }
        public int typeID { get; set; }
        public string groupDescription { get; set; }
        public bool groupUnfollow { get; set; }
        public string createdBy { get; set; }
        public DateTime createdDate { get; set; }
        public DateTime modifiedDate { get; set; }
        public menuGroup() { }
    }
}