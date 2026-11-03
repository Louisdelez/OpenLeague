package blix.util.keyboard
{
   import blix.IDestructible;
   import blix.assets.proxy.DisplayObjectProxy;
   
   public class StageKeyListener implements IDestructible
   {
      
      private var _target:DisplayObjectProxy;
      
      private var _handler:Function;
      
      private var _keyEvent:String;
      
      public function StageKeyListener(param1:DisplayObjectProxy, param2:Function, param3:String = "keyDown")
      {
         super();
         this._target = param1;
         this._handler = param2;
         this._keyEvent = param3;
         this._target.getIsOnStageChanged().add(this.isOnStageChangedHandler);
         this.isOnStageChangedHandler();
      }
      
      protected function isOnStageChangedHandler() : void
      {
         if(this._target.getIsOnStage())
         {
            this._target.getStage().addEventListener(this._keyEvent,this._handler,false,0,true);
         }
         else if(Boolean(this._target.getStage()))
         {
            this._target.getStage().removeEventListener(this._keyEvent,this._handler);
         }
      }
      
      public function destroy() : void
      {
         if(this._target.getIsOnStage())
         {
            this._target.getStage().removeEventListener(this._keyEvent,this._handler);
         }
         this._target.getIsOnStageChanged().remove(this.isOnStageChangedHandler);
      }
   }
}

