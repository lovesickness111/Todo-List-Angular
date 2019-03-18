using Repository.DatabaseAccess;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Repository.Base
{
    /// <summary>
    /// interface kahi báo các hàm cần dùng đề thực hiện đảm bảo toàn vẹn dữ liệu
    /// </summary>
    public interface IUnitOfWork : IDisposable

    {
        IDatabaseContext DataContext { get; }
        SqlTransaction BeginTransaction();
        void Commit();
    }
}