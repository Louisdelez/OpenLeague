package org.igniterealtime.xiff.data.muc
{
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   
   public class MUC
   {
      
      public static var ADMIN_AFFILIATION:String = "admin";
      
      public static var MEMBER_AFFILIATION:String = "member";
      
      public static var NO_AFFILIATION:String = "none";
      
      public static var OUTCAST_AFFILIATION:String = "outcast";
      
      public static var OWNER_AFFILIATION:String = "owner";
      
      public static var MODERATOR_ROLE:String = "moderator";
      
      public static var NO_ROLE:String = "none";
      
      public static var PARTICIPANT_ROLE:String = "participant";
      
      public static var VISITOR_ROLE:String = "visitor";
      
      private static var staticDependencies:Array = [ExtensionClassRegistry,MUCExtension,MUCUserExtension,MUCOwnerExtension,MUCAdminExtension];
      
      public function MUC()
      {
         super();
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(MUCExtension);
         ExtensionClassRegistry.register(MUCUserExtension);
         ExtensionClassRegistry.register(MUCOwnerExtension);
         ExtensionClassRegistry.register(MUCAdminExtension);
      }
   }
}

