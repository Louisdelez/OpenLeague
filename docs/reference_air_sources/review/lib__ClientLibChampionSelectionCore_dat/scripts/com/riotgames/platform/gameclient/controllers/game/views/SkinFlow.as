package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.dougmccune.containers.CoverFlowContainer;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class SkinFlow extends CoverFlowContainer
   {
      
      public static const SKIN_FLOW_FORCE_UPDATE_EVENT:String = "forceUpdateEvent";
      
      public function SkinFlow()
      {
         super();
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         super.addChild(param1);
         param1.addEventListener(SKIN_FLOW_FORCE_UPDATE_EVENT,this.onChildForceUpdate);
         return param1;
      }
      
      private function onChildForceUpdate(param1:Event) : void
      {
         var _loc3_:DisplayObject3D = null;
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         if(Boolean(_loc2_))
         {
            _loc3_ = lookupPlane(_loc2_);
            if(Boolean(_loc3_) && Boolean(_loc3_.material))
            {
               _loc3_.material.updateBitmap();
            }
         }
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         param1.removeEventListener(SKIN_FLOW_FORCE_UPDATE_EVENT,this.onChildForceUpdate);
         return super.removeChild(param1);
      }
   }
}

