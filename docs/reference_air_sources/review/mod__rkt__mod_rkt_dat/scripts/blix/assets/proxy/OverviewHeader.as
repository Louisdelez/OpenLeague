package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class OverviewHeader extends InstanceMapping
   {
      
      public static const LINKAGE:String = "mh.OverviewHeader";
      
      public var outcomeText:TextFieldMapping;
      
      public var ratingChangeText:TextFieldMapping;
      
      public var thisTeamName:TextFieldMapping;
      
      public var otherTeamName:TextFieldMapping;
      
      public var thisTeamScore:TextFieldMapping;
      
      public var otherTeamScore:TextFieldMapping;
      
      public var mapText:TextFieldMapping;
      
      public var gameLengthText:TextFieldMapping;
      
      public function OverviewHeader(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.outcomeText = new TextFieldMapping("outcomeText",this);
         this.ratingChangeText = new TextFieldMapping("ratingChangeText",this);
         this.thisTeamName = new TextFieldMapping("thisTeamName",this);
         this.otherTeamName = new TextFieldMapping("otherTeamName",this);
         this.thisTeamScore = new TextFieldMapping("thisTeamScore",this);
         this.otherTeamScore = new TextFieldMapping("otherTeamScore",this);
         this.mapText = new TextFieldMapping("mapText",this);
         this.gameLengthText = new TextFieldMapping("gameLengthText",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return OverviewHeader.create(param1);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : SpriteProxy
      {
         var _loc2_:String = getName();
         var _loc3_:SpriteProxy = new SpriteProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

