using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace VigShop.Models
{
    public class Product
    {
        public int ID { get; set; }
        public string productName { get; set; }
        public string productCode { get; set; }
        public string productType { get; set; }
        public float productPrice { get; set; }
        public string productSize { get; set; }
        public string productDescription { get; set; }
        public Product() { }
        public Product(int ID, string productName, string productCode, string productType, float productPrice, string productDescription) {
            this.ID = ID;
            this.productName = productName;
            this.productCode = productCode;
            this.productType = productType;
            this.productPrice = productPrice;
            this.productSize = productSize;
            this.productDescription = productDescription;
        }
    }

}