using System;
using Models.Common;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models
{
    public class TaskJob: Entity<Int64>
    {
        public string Title { get; set; }
        public bool Completed { get; set; }
    }
}