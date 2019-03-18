using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Repository.DatabaseAccess
{
    public class DatabaseContextFactory:IDatabaseContextFactory
    {
        private IDatabaseContext dataContext;

        /// <summary>
        /// If data context remain null then initialize new context 
        /// </summary>
        /// <returns>dataContext</returns>
        public IDatabaseContext Context()
        {
            return dataContext ?? (dataContext = new DatabaseContext());
        }

        /// <summary>
        /// Dispose existing context
        /// hủy kết nối khi nhận được response
        /// </summary>
        public void Dispose()
        {
            if (dataContext != null)
                dataContext.Dispose();
        }
    }
}