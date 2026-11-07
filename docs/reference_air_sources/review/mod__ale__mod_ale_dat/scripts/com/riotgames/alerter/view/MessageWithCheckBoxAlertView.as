package com.riotgames.alerter.view
{
   import blix.components.button.CheckBoxX;
   import blix.context.IContext;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWithCheckBoxAction;
   
   public class MessageWithCheckBoxAlertView extends StandardMessageAlertView
   {
      
      private var _checkbox:CheckBoxX;
      
      public function MessageWithCheckBoxAlertView(param1:IContext)
      {
         super(param1);
         setLinkage("CheckBoxAlertView");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._checkbox = new CheckBoxX(this);
         setTimelineChildByName("alertview_checkbox",this._checkbox);
         verticalLayoutContainer.addElement(this._checkbox);
      }
      
      override public function setAlertAction(param1:AlertAction) : void
      {
         super.setAlertAction(param1);
         var _loc2_:AlertWithCheckBoxAction = param1 as AlertWithCheckBoxAction;
         if(_loc2_)
         {
            this._checkbox.setSelected(_loc2_.checkbox_selected);
            this._checkbox.getSelectedChanged().add(this.handleCheckboxChanged);
            this._checkbox.setText(_loc2_.checkbox_text);
            this.updateAffirmativeForCheckbox(_loc2_);
            if(_loc2_.checkbox_above_buttons)
            {
               verticalLayoutContainer.removeElement(this._checkbox);
               verticalLayoutContainer.addElementAt(this._checkbox,1);
            }
         }
      }
      
      private function handleCheckboxChanged() : void
      {
         (_alertAction as AlertWithCheckBoxAction).checkbox_selected = this._checkbox.getSelected();
         this.updateAffirmativeForCheckbox(_alertAction as AlertWithCheckBoxAction);
      }
      
      private function updateAffirmativeForCheckbox(param1:AlertWithCheckBoxAction) : void
      {
         if(param1 != null)
         {
            if(Boolean(param1.affirmative_requires_checkbox_selection) && Boolean(param1.showAffirmative))
            {
               affirmativeButton.setVisible(param1.checkbox_selected);
            }
         }
      }
   }
}

