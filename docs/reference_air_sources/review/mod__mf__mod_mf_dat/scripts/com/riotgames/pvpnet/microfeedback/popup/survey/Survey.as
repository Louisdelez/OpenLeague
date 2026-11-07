package com.riotgames.pvpnet.microfeedback.popup.survey
{
   import blix.components.button.ButtonX;
   import blix.components.button.CheckBoxX;
   import blix.components.button.RadioButtonGroupX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.algorithms.ILayoutAlgorithm;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyDTO;
   import com.riotgames.pvpnet.microfeedback.ClientModuleMicroFeedback;
   import com.riotgames.util.logging.getLogger;
   import mx.logging.ILogger;
   import mx.resources.IResourceManager;
   
   public class Survey extends StatefulView
   {
      
      private static const MICROFEEDBACK_RESOURCE_ID:String = ClientModuleMicroFeedback.MICROFEEDBACK_RESOURCE_ID;
      
      public static const LINKAGE:String = "Survey";
      
      public static const STATE_LIKERT_X5:String = "likert_x5";
      
      public static const STATE_SCALE:String = "scale";
      
      public static const INSTANCE_NAME_BTN:String = "btn_";
      
      public static const LIKE:String = "like_";
      
      public static const AGREE:String = "agree_";
      
      internal var questionText:Text;
      
      internal var questionType:String;
      
      internal var radioButtonGroup:RadioButtonGroupX = new RadioButtonGroupX();
      
      internal var buttons:Vector.<CheckBoxX> = new Vector.<CheckBoxX>();
      
      private var _responseChanged:Signal = new Signal();
      
      private var logger2:ILogger = getLogger(this);
      
      private var resourceManager:IResourceManager;
      
      public function Survey(param1:IContext, param2:SurveyDTO)
      {
         super(param1);
         setLinkage(LINKAGE);
         this.questionSetup(param2);
         this.radioButtonGroup.getSelectedButtonChanged().add(this.selectedButtonChangedHandler);
      }
      
      override protected function initializeDependencies() : void
      {
         this.resourceManager = getDependency(IResourceManager);
         super.initializeDependencies();
      }
      
      private function questionSetup(param1:SurveyDTO) : void
      {
         this.questionType = param1.questionType;
         this.loadQuestionText(param1);
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.setHorizontalAlign(HorizontalAlign.CENTER);
         var _loc3_:HorizontalLayout = new HorizontalLayout();
         _loc3_.setVerticalAlign(VerticalAlign.MIDDLE);
         switch(param1.questionType)
         {
            case QuestionType.MULTIPLE_CHOICE:
               break;
            case QuestionType.NUMBERED_SCALE:
               setCurrentState(STATE_SCALE);
               this.createScaleButtons(7,QuestionType.NUMBERED_SCALE,_loc2_);
               break;
            case QuestionType.LIKERT_AGREE_X5:
               setCurrentState(STATE_LIKERT_X5);
               this.createScaleButtons(5,QuestionType.LIKERT_AGREE_X5,_loc3_);
               break;
            case QuestionType.LIKERT_LIKE_X5:
               setCurrentState(STATE_LIKERT_X5);
               this.createScaleButtons(5,QuestionType.LIKERT_LIKE_X5,_loc3_);
               break;
            case QuestionType.OPEN_RESPONSE:
         }
      }
      
      private function loadQuestionText(param1:SurveyDTO) : void
      {
         if(this.questionText == null)
         {
            this.questionText = new Text(this);
            setTimelineChildByName("question_txt",this.questionText);
         }
         this.questionText.setText(param1.questionContent);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      private function createScaleButtons(param1:int, param2:String, param3:ILayoutAlgorithm) : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            this.buttons[_loc4_] = new CheckBoxX(this);
            if(param2 == QuestionType.NUMBERED_SCALE)
            {
               this.buttons[_loc4_].setText(String(_loc4_ + 1));
            }
            else if(param2 == QuestionType.LIKERT_AGREE_X5)
            {
               this.buttons[_loc4_].setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,AGREE + String(_loc4_ + 1)));
            }
            else if(param2 == QuestionType.LIKERT_LIKE_X5)
            {
               this.buttons[_loc4_].setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,LIKE + String(_loc4_ + 1)));
            }
            this.buttons[_loc4_].setData(String(_loc4_ + 1));
            this.buttons[_loc4_].setEnabled(true);
            setTimelineChildByName(INSTANCE_NAME_BTN + String(_loc4_),this.buttons[_loc4_]);
            this.buttons[_loc4_].setLayoutAlgorithm(param3);
            this.radioButtonGroup.addRadioButton(this.buttons[_loc4_]);
            _loc4_++;
         }
      }
      
      override public function destroy() : void
      {
         this._responseChanged.removeAll();
         this.radioButtonGroup.getSelectedButtonChanged().removeAll();
         this.radioButtonGroup.destroy();
         this.buttons = null;
         super.destroy();
      }
      
      private function selectedButtonChangedHandler(param1:RadioButtonGroupX, param2:ButtonX, param3:ButtonX) : void
      {
         if(param3 != null)
         {
            this._responseChanged.dispatch(this,String(param3.getData()));
         }
         else
         {
            this._responseChanged.dispatch(this,null);
         }
      }
      
      public function getResponse() : String
      {
         var _loc1_:String = null;
         if(this.questionType == QuestionType.OPEN_RESPONSE)
         {
            return _loc1_;
         }
         if(this.radioButtonGroup.getSelectedButton() != null)
         {
            _loc1_ = String(this.radioButtonGroup.getSelectedButton().getData());
         }
         return _loc1_;
      }
      
      public function getResponseChanged() : ISignal
      {
         return this._responseChanged;
      }
   }
}

