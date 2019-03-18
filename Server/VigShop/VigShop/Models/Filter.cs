using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace VigShop.Models
{
    public class Filter
    {
        public string FieldName { get; set; }
        public string Type { get; set; }
        public string Value { get; set; }
        ///build câu truy vấn với nhiều kiểu tùy chọn
        public static string BuildWhereString(List<Filter> filters)
        {
            StringBuilder where = new StringBuilder();

            //trong truong hop khong truyen vao kieu loc cau truy van se lay ra toan bo
            where.Append("AND 1=1");

            if (filters != null)
            {
                foreach (var item in filters)
                {
                    switch (item.Type)
                    {
                        case "=": //bằng
                            where.AppendFormat(" AND {0} = N'{1}'", item.FieldName, item.Value.Trim());
                            break;
                        case "+": //bắt đầu bằng
                            where.AppendFormat(" AND {0} LIKE N'{1}%'", item.FieldName, item.Value.Trim());
                            break;
                        case "-": //kết thúc bằng
                            where.AppendFormat(" AND {0} LIKE N'%{1}'", item.FieldName, item.Value.Trim());
                            break;
                        case "!": //không chứa
                            where.AppendFormat(" AND {0} <> N'{1}'", item.FieldName, item.Value.Trim());
                            break;
                        case "*": //chứa
                            where.AppendFormat(" AND {0} LIKE N'%{1}%'", item.FieldName, item.Value.Trim());
                            break;
                        default:
                            where.AppendFormat(" AND {0} {1} N'%{2}%'", item.FieldName, item.Type, item.Value.Trim());
                            break;
                    }
                }
            }

            return where.ToString();
        }
    }
}