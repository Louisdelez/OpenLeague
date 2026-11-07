package mx.utils
{
   import mx.core.ISWFBridgeProvider;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SecurityUtil
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function SecurityUtil()
      {
         super();
      }
      
      public static function hasMutualTrustBetweenParentAndChild(bp:ISWFBridgeProvider) : Boolean
      {
         if(Boolean(bp) && Boolean(bp.childAllowsParent) && bp.parentAllowsChild)
         {
            return true;
         }
         return false;
      }
   }
}

