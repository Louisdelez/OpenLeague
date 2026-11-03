package blix.components.button
{
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.model.ITextModel;
   import blix.model.TextModel;
   
   public class LabelButtonX extends ButtonX
   {
      
      public var textField:Text;
      
      public function LabelButtonX(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.textField == null)
         {
            this.textField = new Text(this);
            setTimelineChildByName("textField",this.textField);
         }
      }
      
      public function setText(param1:String) : void
      {
         this.textField.setText(param1);
      }
      
      public function getTextModel() : ITextModel
      {
         return this.textField.getTextModel();
      }
      
      public function setTextModel(param1:TextModel, param2:Boolean = false) : void
      {
         this.textField.setTextModel(param1,param2);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.textField.destroy();
      }
   }
}

