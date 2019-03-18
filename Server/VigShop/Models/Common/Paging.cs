using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Models.Common
{
    /// <summary>
    /// đối tượng phân trang
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class Paging<T>
    {
        /// <summary>
        /// List dữ liệu lấy được
        /// </summary>
        public List<T> Entities { get; set; }
        /// <summary>
        /// trả về từ server có bn trang
        /// </summary>
        public int TotalPage { get; set; }
        /// <summary>
        /// trả về từ server có bn bản ghi
        /// </summary>
        public int TotalRecord { get; set; }
    }
}