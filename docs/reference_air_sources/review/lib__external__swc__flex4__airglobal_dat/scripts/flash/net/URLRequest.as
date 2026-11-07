package flash.net
{
   [native(cls="URLRequestClass",gc="exact",instance="URLRequestObject",methods="auto")]
   public final class URLRequest
   {
      
      private static const kInvalidParamError:uint = 2004;
      
      public function URLRequest(url:String = null)
      {
         super();
         if(url != null)
         {
            this.url = url;
         }
         this.requestHeaders = [];
      }
      
      public native function get url() : String;
      
      public native function set url(param1:String) : void;
      
      public native function get data() : Object;
      
      public native function set data(param1:Object) : void;
      
      public native function get method() : String;
      
      public function set method(value:String) : void
      {
         var re:RegExp = /^(\x21|[\x23-\x26]|\x2A|\x2B|\x2D|\x2E|[\x30-\x39]|[\x41-\x5A]|[\x5E-\x7A])+$/;
         if(!re.test(value))
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         this.setMethod(value);
      }
      
      private native function setMethod(param1:String) : void;
      
      public native function get contentType() : String;
      
      public native function set contentType(param1:String) : void;
      
      public native function get requestHeaders() : Array;
      
      public function set requestHeaders(value:Array) : void
      {
         if(value != null)
         {
            this.setRequestHeaders(value.filter(this.filterRequestHeaders));
         }
         else
         {
            this.setRequestHeaders(value);
         }
      }
      
      private native function setRequestHeaders(param1:Array) : void;
      
      private function filterRequestHeaders(item:*, index:int, array:Array) : Boolean
      {
         if(item instanceof URLRequestHeader && item.name.toLowerCase() == "user-agent")
         {
            try
            {
               this.userAgent = item.value;
               return false;
            }
            catch(e:*)
            {
            }
         }
         return true;
      }
      
      public native function get digest() : String;
      
      public native function set digest(param1:String) : void;
      
      private function shouldFilterHTTPHeader(header:String) : Boolean
      {
         return false;
      }
      
      [API("661")]
      public native function get followRedirects() : Boolean;
      
      [API("661")]
      public native function set followRedirects(param1:Boolean) : void;
      
      [API("661")]
      public native function get userAgent() : String;
      
      [API("661")]
      public native function set userAgent(param1:String) : void;
      
      [API("661")]
      public native function get manageCookies() : Boolean;
      
      [API("661")]
      public native function set manageCookies(param1:Boolean) : void;
      
      [API("661")]
      public native function get useCache() : Boolean;
      
      [API("661")]
      public native function set useCache(param1:Boolean) : void;
      
      [API("661")]
      public native function get cacheResponse() : Boolean;
      
      [API("661")]
      public native function set cacheResponse(param1:Boolean) : void;
      
      private native function _SetIdleTimeout(param1:Number) : void;
      
      [Version("air2.0")]
      public native function get idleTimeout() : Number;
      
      [Version("air2.0")]
      public function set idleTimeout(value:Number) : void
      {
         if(value < 0)
         {
            Error.throwError(RangeError,2006);
         }
         this._SetIdleTimeout(value);
      }
      
      [API("661")]
      public native function get authenticate() : Boolean;
      
      [API("661")]
      public native function set authenticate(param1:Boolean) : void;
   }
}

