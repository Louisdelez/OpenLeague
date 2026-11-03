package blix.components.menu
{
   import blix.IDestructible;
   import blix.model.ITextModel;
   import flash.display.NativeMenuItem;
   
   public class NativeMenuItemX extends NativeMenuItem implements IDestructible
   {
      
      private var _textModel:ITextModel;
      
      private var _keyTextModel:ITextModel;
      
      public function NativeMenuItemX(param1:ITextModel = null, param2:Boolean = false)
      {
         super("",param2);
         this.setTextModel(param1);
      }
      
      public function getTextModel() : ITextModel
      {
         return this._textModel;
      }
      
      public function setTextModel(param1:ITextModel) : void
      {
         if(this._textModel == param1)
         {
            return;
         }
         if(this._textModel != null)
         {
            this._textModel.getTextChanged().remove(this.refreshLabel);
         }
         this._textModel = param1;
         if(this._textModel != null)
         {
            this._textModel.getTextChanged().add(this.refreshLabel);
         }
         this.refreshLabel();
      }
      
      protected function refreshLabel() : void
      {
         if(this._textModel == null)
         {
            label = "";
         }
         else if(keyEquivalent == null)
         {
            label = this._textModel.getText();
         }
         else
         {
            label = this._textModel.getText() + " ";
         }
      }
      
      public function destroy() : void
      {
         this.setTextModel(null);
         if(submenu is IDestructible)
         {
            (submenu as IDestructible).destroy();
         }
      }
      
      public function setKeyEquivalentModel(param1:ITextModel) : void
      {
         if(this._keyTextModel == param1)
         {
            return;
         }
         if(this._keyTextModel != null)
         {
            this._keyTextModel.getTextChanged().remove(this.keyModelChanged);
         }
         this._keyTextModel = param1;
         if(this._keyTextModel != null)
         {
            this._keyTextModel.getTextChanged().add(this.keyModelChanged);
         }
         this.keyModelChanged();
      }
      
      private function keyModelChanged() : void
      {
         this.keyEquivalent = this._keyTextModel == null ? "" : this._keyTextModel.getText();
      }
      
      override public function set keyEquivalent(param1:String) : void
      {
         super.keyEquivalent = param1;
         this.refreshLabel();
      }
   }
}

