using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Repository.DatabaseAccess
{
    /// <summary>
    /// Interface thực hiện get only 1 connection
    /// </summary>
    public interface IDatabaseContext:IDisposable
    {
        SqlConnection Connection { get; }
    }
}