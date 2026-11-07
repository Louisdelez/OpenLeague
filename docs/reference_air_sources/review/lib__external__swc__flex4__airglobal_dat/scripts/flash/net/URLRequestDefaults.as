package flash.net
{
   import flash.system.*;
   
   [native(cls="URLRequestDefaultsClass",methods="auto")]
   public class URLRequestDefaults
   {
      
      private static var _followRedirects:Boolean = true;
      
      private static var _manageCookies:Boolean = true;
      
      private static var _authenticate:Boolean = true;
      
      private static var _useCache:Boolean = true;
      
      private static var _cacheResponse:Boolean = true;
      
      private static var _idleTimeout:Number = 0;
      
      private static var _userAgent:String = null;
      
      private static var _loginCredentials:* = initLoginCredentials();
      
      private static var _defaultUserAgent:String = initUA();
      
      private static const kApplicationFeatureSecurityError:uint = 3205;
      
      public function URLRequestDefaults()
      {
         super();
      }
      
      public static function get followRedirects() : Boolean
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         return _followRedirects;
      }
      
      public static function set followRedirects(value:Boolean) : void
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         _followRedirects = value;
      }
      
      public static function get manageCookies() : Boolean
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         return _manageCookies;
      }
      
      public static function set manageCookies(value:Boolean) : void
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         _manageCookies = value;
      }
      
      public static function get authenticate() : Boolean
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         return _authenticate;
      }
      
      public static function set authenticate(value:Boolean) : void
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         _authenticate = value;
      }
      
      public static function get useCache() : Boolean
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         return _useCache;
      }
      
      public static function set useCache(value:Boolean) : void
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         _useCache = value;
      }
      
      public static function get cacheResponse() : Boolean
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         return _cacheResponse;
      }
      
      public static function set cacheResponse(value:Boolean) : void
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         _cacheResponse = value;
      }
      
      [Version("air2.0")]
      public static function get idleTimeout() : Number
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         return _idleTimeout;
      }
      
      [Version("air2.0")]
      public static function set idleTimeout(value:Number) : void
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         if(value < 0)
         {
            Error.throwError(RangeError,2006);
         }
         _idleTimeout = value;
      }
      
      public static function get userAgent() : String
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         if(Boolean(_userAgent))
         {
            return _userAgent;
         }
         return _defaultUserAgent;
      }
      
      public static function set userAgent(value:String) : void
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         _userAgent = value;
      }
      
      public static function setLoginCredentialsForHost(hostname:String, user:String, password:String) : *
      {
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,kApplicationFeatureSecurityError);
         }
         _loginCredentials[hostname] = {
            "user":user,
            "pw":password
         };
      }
      
      private static native function initLoginCredentials() : Object;
      
      private static native function initUA() : String;
   }
}

