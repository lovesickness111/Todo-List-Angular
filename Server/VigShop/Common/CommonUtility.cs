using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Xml;
using System.Configuration;

namespace Common
{
    /// <summary>
    /// Class chứa các phương thức dùng chung
    /// </summary>
    /// Created by: nvcuong (16.03.2017)
    public class CommonUtility
    {
        public static string GetAppSettingByKey(string keyValue)
        {
            return ConfigurationManager.AppSettings[keyValue];
        }
    }
}
