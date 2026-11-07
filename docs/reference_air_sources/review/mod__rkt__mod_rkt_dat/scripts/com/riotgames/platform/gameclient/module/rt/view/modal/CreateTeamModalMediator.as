package com.riotgames.platform.gameclient.module.rt.view.modal
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.controller.RTShowServiceError;
   import com.riotgames.platform.gameclient.module.rt.model.CreateTeamErrorCode;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.controls.Label;
   import mx.managers.PopUpManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class CreateTeamModalMediator extends Mediator
   {
      
      public static var NAME:String = "CreateTeamModalMediator";
      
      private var tagInfoHelp:FlashFlexComponent;
      
      private var tagIcon:FlashFlexComponent;
      
      public function CreateTeamModalMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      private static function get wordFilter() : WordFilter
      {
         return RTFacade.instance.rtProvider.wordFilter;
      }
      
      public static function setCreateNameInfoText(param1:Label, param2:String, param3:Boolean) : void
      {
         param1.text = param2;
         if(param3)
         {
            param1.setStyle("color","#FF0000");
         }
         else
         {
            param1.setStyle("color","#00FF00");
         }
      }
      
      private function validateName() : Boolean
      {
         var _loc1_:String = this.view.txtTeamNameCreate.text;
         var _loc2_:Boolean = false;
         if(wordFilter.containsOffensiveWords(_loc1_,true))
         {
            this.onNameError(CreateTeamErrorCode.INVALID_TEAM_NAME_FILTER);
            _loc2_ = true;
         }
         else if(wordFilter.containsRestrictedWords(_loc1_,true))
         {
            this.onNameError(CreateTeamErrorCode.INVALID_TEAM_NAME_FILTER);
            _loc2_ = true;
         }
         else if(wordFilter.getInvalidCharacters(_loc1_))
         {
            this.onNameError(CreateTeamErrorCode.INVALID_TEAM_NAME_CHARACTERS);
            _loc2_ = true;
         }
         else if(_loc1_.length < 3 || _loc1_.length > 24)
         {
            this.onNameError(CreateTeamErrorCode.INVALID_TEAM_NAME_LENGTH);
            _loc2_ = true;
         }
         return !_loc2_;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.charCode == Keyboard.ENTER)
         {
            this.onCreateClicked(null);
         }
      }
      
      private function onTagExistenceCheck(param1:Object) : void
      {
         if(param1.result)
         {
            setCreateNameInfoText(this.view.txtTagInfo,RTResource.getString("createTeamValidateTagFree"),false);
         }
         else
         {
            setCreateNameInfoText(this.view.txtTagInfo,RTResource.getString("createTeamValidateTagTaken"),true);
         }
      }
      
      public function onTagError(param1:String) : void
      {
         setCreateNameInfoText(this.view.txtTagInfo,RTResource.getString("RT_" + param1),true);
      }
      
      private function onNameExistenceCheck(param1:Object) : void
      {
         if(param1.result)
         {
            setCreateNameInfoText(this.view.txtNameInfo,RTResource.getString("createTeamValidateNameFree"),false);
         }
         else
         {
            setCreateNameInfoText(this.view.txtNameInfo,RTResource.getString("createTeamValidateNameTaken"),true);
         }
      }
      
      public function onCheckTeamTagClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this.validateTag();
         if(_loc2_)
         {
            RTFacade.teamProxy.isTagAvailable(this.view.txtTeamTag.text);
         }
      }
      
      private function onTagIconMouseOut(param1:MouseEvent) : void
      {
         this.tagInfoHelp.visible = false;
      }
      
      public function onNameError(param1:String) : void
      {
         setCreateNameInfoText(this.view.txtNameInfo,RTResource.getString("RT_" + param1),true);
      }
      
      private function closeDialog(param1:MouseEvent = null) : void
      {
         RTFacade.instance.removeMediator(CreateTeamModalMediator.NAME);
         PopUpManager.removePopUp(this.view);
      }
      
      override public function onRegister() : void
      {
         var _loc1_:RTContext = RTFacade.context;
         this.view.btnCreate.addEventListener(MouseEvent.CLICK,this.onCreateClicked,false,0,true);
         this.view.btnCancel.addEventListener(MouseEvent.CLICK,this.closeDialog,false,0,true);
         this.view.txtTeamNameCreate.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         this.view.txtTeamTag.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         this.view.btnCheckTeamName.addEventListener(MouseEvent.CLICK,this.onCheckTeamNameClick,false,0,true);
         this.view.btnCheckTeamTag.addEventListener(MouseEvent.CLICK,this.onCheckTeamTagClick,false,0,true);
         this.tagIcon = new FlashFlexComponent(_loc1_,"rt.SimpleStatusIcon");
         this.tagIcon.addEventListener(MouseEvent.MOUSE_OVER,this.onTagIconMouseOver,false,0,true);
         this.tagIcon.addEventListener(MouseEvent.MOUSE_OUT,this.onTagIconMouseOut,false,0,true);
         this.tagInfoHelp = new FlashFlexComponent(_loc1_,"rt.TagInfoHelp");
         this.tagInfoHelp.x = 26;
         this.tagInfoHelp.y = 12;
         this.tagInfoHelp.visible = false;
         this.view.teamTagCanvas.addChild(this.tagIcon);
         this.tagIcon.addChild(this.tagInfoHelp);
         PopUpManager.centerPopUp(this.view);
      }
      
      private function validateTag() : Boolean
      {
         var _loc1_:String = this.view.txtTeamTag.text;
         var _loc2_:Boolean = false;
         if(wordFilter.containsOffensiveWords(_loc1_,true))
         {
            this.onTagError(CreateTeamErrorCode.INVALID_TEAM_TAG_FILTER);
            _loc2_ = true;
         }
         else if(wordFilter.containsRestrictedWords(_loc1_,true))
         {
            this.onTagError(CreateTeamErrorCode.INVALID_TEAM_TAG_FILTER);
            _loc2_ = true;
         }
         else if(wordFilter.getInvalidCharacters(_loc1_))
         {
            this.onTagError(CreateTeamErrorCode.INVALID_TEAM_TAG_CHARACTERS);
            _loc2_ = true;
         }
         else if(_loc1_.length < 3 || _loc1_.length > 6)
         {
            this.onTagError(CreateTeamErrorCode.INVALID_TEAM_TAG_LENGTH);
            _loc2_ = true;
         }
         return !_loc2_;
      }
      
      public function get view() : CreateTeamModal
      {
         return viewComponent as CreateTeamModal;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [RTNotificationConstants.RT_MODULE_TEARDOWN,TeamProxy.CREATE_TEAM_SUCCESS,TeamProxy.DOES_NAME_EXIST,TeamProxy.DOES_TAG_EXIST,TeamProxy.CREATE_TEAM_ERROR,TeamProxy.NAME_TAG_VALIDATION_ERROR];
      }
      
      private function onCreateClicked(param1:MouseEvent) : void
      {
         this.resetCreateNameLabels();
         if(this.validateName() && this.validateTag())
         {
            RTFacade.teamProxy.createTeam(this.view.txtTeamNameCreate.text,this.view.txtTeamTag.text);
         }
      }
      
      private function onError(param1:ServerError) : void
      {
         if(param1.errorCode == CreateTeamErrorCode.NAME_ALREADY_TAKEN || param1.errorCode == CreateTeamErrorCode.INVALID_TEAM_NAME_USED_BY_OTHER_TAG || param1.errorCode == CreateTeamErrorCode.INVALID_TEAM_NAME_CHARACTERS)
         {
            this.onNameError(param1.errorCode);
         }
         else if(param1.errorCode == CreateTeamErrorCode.TAG_ALREADY_TAKEN || param1.errorCode == CreateTeamErrorCode.INVALID_TEAM_TAG_USED_BY_OTHER_NAME || param1.errorCode == CreateTeamErrorCode.INVALID_TEAM_TAG_CHARACTERS)
         {
            this.onTagError(param1.errorCode);
         }
         else
         {
            RTFacade.instance.sendNotification(RTShowServiceError.SHOW_ERROR,param1);
            this.closeDialog();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case TeamProxy.CREATE_TEAM_SUCCESS:
               this.closeDialog();
               break;
            case TeamProxy.CREATE_TEAM_ERROR:
               this.onError(param1.getBody() as ServerError);
               break;
            case TeamProxy.DOES_NAME_EXIST:
               this.onNameExistenceCheck(param1.getBody());
               break;
            case TeamProxy.DOES_TAG_EXIST:
               this.onTagExistenceCheck(param1.getBody());
               break;
            case TeamProxy.NAME_TAG_VALIDATION_ERROR:
               this.onError(param1.getBody() as ServerError);
               break;
            case RTNotificationConstants.RT_MODULE_TEARDOWN:
         }
      }
      
      private function onTagIconMouseOver(param1:MouseEvent) : void
      {
         this.tagInfoHelp.visible = true;
      }
      
      public function resetCreateNameLabels() : void
      {
         this.view.txtNameInfo.text = "";
         this.view.txtTagInfo.text = "";
      }
      
      public function onCheckTeamNameClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this.validateName();
         if(_loc2_)
         {
            RTFacade.teamProxy.isNameAvailable(this.view.txtTeamNameCreate.text);
         }
      }
   }
}

