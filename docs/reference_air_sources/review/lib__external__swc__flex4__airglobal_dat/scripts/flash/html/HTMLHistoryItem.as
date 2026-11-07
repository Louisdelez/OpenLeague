package flash.html
{
   [API("661")]
   public class HTMLHistoryItem
   {
      
      private var _url:String;
      
      private var _originalUrl:String;
      
      private var _isPost:Boolean;
      
      private var _title:String;
      
      public function HTMLHistoryItem(url:String, originalUrl:String, isPost:Boolean, title:String)
      {
         super();
         this._url = url;
         this._originalUrl = originalUrl;
         this._isPost = isPost;
         this._title = title;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get originalUrl() : String
      {
         return this._originalUrl;
      }
      
      public function get isPost() : Boolean
      {
         return this._isPost;
      }
      
      public function get title() : String
      {
         return this._title;
      }
   }
}

