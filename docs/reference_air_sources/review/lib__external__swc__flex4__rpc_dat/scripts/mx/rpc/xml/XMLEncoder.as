package mx.rpc.xml
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import mx.collections.IList;
   import mx.messaging.config.LoaderConfig;
   import mx.utils.ObjectProxy;
   import mx.utils.ObjectUtil;
   import mx.utils.object_proxy;
   
   [ExcludeClass]
   public class XMLEncoder extends SchemaProcessor implements IXMLEncoder
   {
      
      private var _strictNillability:Boolean = false;
      
      private var _xmlSpecialCharsFilter:Function = this.escapeXML;
      
      private var _escapeXMLChars:Boolean = true;
      
      public function XMLEncoder()
      {
         super();
         if(LoaderConfig.swfVersion >= 10)
         {
            this._escapeXMLChars = false;
         }
      }
      
      public function encode(value:*, name:QName = null, type:QName = null, definition:XML = null) : XMLList
      {
         var content:XML = null;
         var elementDefinition:XML = null;
         var mustReleaseScope:Boolean = false;
         var result:XMLList = new XMLList();
         if(name == null)
         {
            name = new QName("","root");
         }
         if(type != null)
         {
            content = this.encodeXSINil(null,name,value);
            if(content == null)
            {
               content = this.createElement(name);
               if(value == null)
               {
                  this.setValue(content,null);
               }
               else
               {
                  this.encodeType(type,content,name,value);
               }
            }
         }
         else
         {
            elementDefinition = definition;
            mustReleaseScope = false;
            if(elementDefinition == null)
            {
               elementDefinition = schemaManager.getNamedDefinition(name,constants.elementTypeQName);
               if(elementDefinition != null)
               {
                  mustReleaseScope = true;
               }
            }
            content = this.encodeElementTopLevel(elementDefinition,name,value);
            if(mustReleaseScope)
            {
               schemaManager.releaseScope();
            }
         }
         if(content != null)
         {
            result += content;
         }
         return result;
      }
      
      public function encodeAll(definition:XML, parent:XMLList, name:QName, value:*, isRequired:Boolean = true) : Boolean
      {
         return this.encodeSequence(definition,parent,name,value,isRequired);
      }
      
      public function encodeAnyAttribute(definition:XML, parent:XML, name:QName, value:* = undefined, restriction:XML = null) : void
      {
         var propertyName:Object = null;
         var attributeValue:* = undefined;
         if(value !== undefined)
         {
            if(!this.isSimpleValue(value) && !(value is Array))
            {
               for(propertyName in this.getProperties(value))
               {
                  if(!this.hasAttribute(value,propertyName) && !this.hasValue(value,propertyName))
                  {
                     attributeValue = this.getAttribute(value,propertyName);
                     if(attributeValue != null)
                     {
                        this.setAttribute(parent,propertyName,attributeValue);
                     }
                  }
               }
            }
         }
      }
      
      public function encodeAnyElement(definition:XML, siblings:XMLList, name:QName, value:*, isRequired:Boolean = true, encodedVals:Dictionary = null) : Boolean
      {
         var item:XML = null;
         var arrValue:* = undefined;
         var arrayItem:* = undefined;
         var arrayChildren:XMLList = null;
         var objProperty:Object = null;
         var propValue:* = undefined;
         var propQName:QName = null;
         var propItem:XML = null;
         var propChildren:XMLList = null;
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(this.isSimpleValue(value))
         {
            item = this.createElement(name);
            this.setValue(item,value);
            this.appendValue(siblings,item);
         }
         else if(value is XML || value is XMLList)
         {
            this.appendValue(siblings,value);
         }
         else
         {
            if(encodedVals == null)
            {
               encodedVals = new Dictionary(true);
            }
            if(!(value is QName))
            {
               if(encodedVals[value] != null)
               {
                  throw new Error("Cannot encode complex structure. Cyclic references detected.");
               }
               encodedVals[value] = true;
            }
            if(value is Array || value is IList)
            {
               if(value is IList)
               {
                  value = IList(value).toArray();
               }
               for each(arrValue in value as Array)
               {
                  arrayItem = this.createElement(name);
                  if(arrValue == null)
                  {
                     this.setValue(arrayItem,null);
                  }
                  else if(arrValue != null)
                  {
                     arrayChildren = new XMLList();
                     this.encodeAnyElement(definition,arrayChildren,name,arrValue,isRequired,encodedVals);
                     if(this.isSimpleValue(arrValue))
                     {
                        arrayItem = arrayChildren[0];
                     }
                     else
                     {
                        this.setValue(arrayItem,arrayChildren);
                     }
                  }
                  this.appendValue(siblings,arrayItem);
               }
            }
            else
            {
               for each(objProperty in this.getProperties(value))
               {
                  propValue = this.getValue(value,objProperty);
                  propQName = new QName(name.uri,objProperty);
                  if(!this.containsNodeByName(siblings,propQName))
                  {
                     propItem = this.encodeXSINil(definition,propQName,propValue);
                     if(propItem != null)
                     {
                        this.appendValue(siblings,propItem);
                     }
                     else if(propValue != null)
                     {
                        propChildren = new XMLList();
                        this.encodeAnyElement(definition,propChildren,propQName,propValue,isRequired,encodedVals);
                        this.appendValue(siblings,propChildren);
                     }
                  }
               }
            }
            delete encodedVals[value];
         }
         return true;
      }
      
      public function encodeAttribute(definition:XML, parent:XML, name:QName, value:* = undefined, restriction:XML = null) : void
      {
         var ref:QName = null;
         var attributeName:QName = null;
         var attributeFixed:String = null;
         var tempElement:* = undefined;
         var attributeFound:Boolean = false;
         var attributeDefault:String = null;
         var typeDefinition:XML = null;
         var typeName:String = null;
         var attributeType:QName = null;
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.attributeQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve attribute definition for \'" + ref + "\'");
            }
         }
         var attributeNameString:String = definition.@name.toString();
         var attributeUse:String = definition.attribute("use").toString();
         if(attributeUse != "prohibited")
         {
            attributeName = schemaManager.getQNameForAttribute(attributeNameString,getAttributeFromNode("form",definition));
            attributeFixed = getAttributeFromNode("fixed",definition);
            if(attributeFixed != null)
            {
               value = attributeFixed;
            }
            else
            {
               value = this.getValue(value,attributeName);
               if(value === undefined)
               {
                  attributeDefault = getAttributeFromNode("default",definition);
                  if(attributeDefault != null)
                  {
                     value = attributeDefault;
                  }
               }
            }
            if(value !== undefined)
            {
               tempElement = <temp/>;
               typeName = getAttributeFromNode("type",definition);
               if(typeName != null)
               {
                  attributeType = schemaManager.getQNameForPrefixedName(definition.@type,definition);
               }
               else
               {
                  attributeType = schemaManager.schemaDatatypes.anySimpleTypeQName;
               }
               if(attributeType != null)
               {
                  if(isBuiltInType(attributeType))
                  {
                     tempElement.appendChild(schemaManager.marshall(value,attributeType,restriction));
                  }
                  else
                  {
                     typeDefinition = schemaManager.getNamedDefinition(attributeType,constants.simpleTypeQName);
                     if(typeDefinition == null)
                     {
                        throw new Error("Cannot find simpleType " + attributeType + " for attribute " + attributeName);
                     }
                     this.encodeSimpleType(typeDefinition,tempElement,attributeName,value,restriction);
                     schemaManager.releaseScope();
                  }
               }
               else
               {
                  typeDefinition = getSingleElementFromNode(definition,constants.simpleTypeQName);
                  if(typeDefinition != null)
                  {
                     this.encodeSimpleType(typeDefinition,tempElement,attributeName,value,restriction);
                  }
                  else if(value != null)
                  {
                     tempElement.appendChild(value.toString());
                  }
               }
            }
            if(tempElement !== undefined)
            {
               this.setAttribute(parent,attributeName,tempElement);
            }
         }
         if(ref != null)
         {
            schemaManager.releaseScope();
         }
      }
      
      public function encodeAttributeGroup(definition:XML, parent:XML, name:QName, value:* = undefined, restriction:XML = null) : void
      {
         var ref:QName = null;
         var attributeDefinition:XML = null;
         var attributeGroups:XMLList = null;
         var attributeGroup:XML = null;
         var anyAttribute:XML = null;
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.attributeGroupQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve attributeGroup definition for \'" + ref + "\'");
            }
         }
         var attributes:XMLList = definition.elements(constants.attributeQName);
         for each(attributeDefinition in attributes)
         {
            this.encodeAttribute(attributeDefinition,parent,name,value,restriction);
         }
         attributeGroups = definition.elements(constants.attributeGroupQName);
         for each(attributeGroup in attributeGroups)
         {
            this.encodeAttributeGroup(attributeGroup,parent,name,value,restriction);
         }
         anyAttribute = getSingleElementFromNode(definition,constants.anyAttributeQName);
         if(anyAttribute != null)
         {
            this.encodeAnyAttribute(anyAttribute,parent,name,value,restriction);
         }
         if(ref != null)
         {
            schemaManager.releaseScope();
         }
      }
      
      public function encodeChoice(definition:XML, parent:XMLList, name:QName, value:*, isRequired:Boolean = true) : Boolean
      {
         var lastIndex:uint = 0;
         var choiceOccurs:uint = 0;
         var childDefinition:XML = null;
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(maxOccurs == 0)
         {
            return false;
         }
         if(value == null && minOccurs == 0)
         {
            return true;
         }
         var choiceElements:XMLList = definition.elements();
         var choiceSatisfied:Boolean = true;
         if(choiceElements.length() > 0)
         {
            choiceSatisfied = false;
         }
         for each(childDefinition in choiceElements)
         {
            if(childDefinition.name() == constants.elementTypeQName)
            {
               choiceSatisfied = this.encodeGroupElement(childDefinition,parent,name,value,false) || choiceSatisfied;
            }
            else if(childDefinition.name() == constants.sequenceQName)
            {
               choiceSatisfied = this.encodeSequence(childDefinition,parent,name,value,false) || choiceSatisfied;
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               choiceSatisfied = this.encodeGroupReference(childDefinition,parent,name,value,false) || choiceSatisfied;
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               choiceSatisfied = this.encodeChoice(childDefinition,parent,name,value,false) || choiceSatisfied;
            }
            else if(childDefinition.name() == constants.anyQName)
            {
               choiceSatisfied = this.encodeAnyElement(childDefinition,parent,name,value,false) || choiceSatisfied;
            }
         }
         return choiceSatisfied;
      }
      
      public function encodeComplexContent(definition:XML, parent:XML, name:QName, value:*) : void
      {
         var childDefinition:XML = getSingleElementFromNode(definition,constants.extensionQName,constants.restrictionQName);
         if(childDefinition.name() == constants.extensionQName)
         {
            this.encodeComplexExtension(childDefinition,parent,name,value);
         }
         else if(childDefinition.name() == constants.restrictionQName)
         {
            this.encodeComplexRestriction(childDefinition,parent,name,value);
         }
      }
      
      public function encodeComplexExtension(definition:XML, parent:XML, name:QName, value:*) : void
      {
         var childDefinition:XML = null;
         var extension:XML = null;
         var baseName:String = getAttributeFromNode("base",definition);
         if(baseName == null)
         {
            throw new Error("A complexContent extension must declare a base type.");
         }
         var baseType:QName = schemaManager.getQNameForPrefixedName(baseName,definition);
         var baseDefinition:XML = schemaManager.getNamedDefinition(baseType,constants.complexTypeQName);
         if(baseDefinition == null)
         {
            throw new Error("Cannot find base type definition \'" + baseType + "\'");
         }
         this.encodeComplexType(baseDefinition,parent,name,value);
         schemaManager.releaseScope();
         var childDefinitions:XMLList = definition.elements();
         var extChildren:XMLList = new XMLList();
         for each(childDefinition in childDefinitions)
         {
            if(childDefinition.name() == constants.sequenceQName)
            {
               this.encodeSequence(childDefinition,extChildren,name,value);
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               this.encodeGroupReference(childDefinition,extChildren,name,value);
            }
            else if(childDefinition.name() == constants.allQName)
            {
               this.encodeAll(childDefinition,extChildren,name,value);
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               this.encodeChoice(childDefinition,extChildren,name,value);
            }
            else if(childDefinition.name() == constants.attributeQName)
            {
               this.encodeAttribute(childDefinition,parent,name,value);
            }
            else if(childDefinition.name() == constants.attributeGroupQName)
            {
               this.encodeAttributeGroup(childDefinition,parent,name,value);
            }
            else if(childDefinition.name() == constants.anyAttributeQName)
            {
               this.encodeAnyAttribute(childDefinition,parent,name,value);
            }
         }
         for each(extension in extChildren)
         {
            delete parent[extension.name()];
            delete parent[new QName("",extension.name().localName)];
            delete parent[new QName(null,extension.name().localName)];
         }
         this.setValue(parent,extChildren);
      }
      
      public function encodeComplexRestriction(restriction:XML, parent:XML, name:QName, value:*) : void
      {
         var childDefinition:XML = null;
         var baseName:String = getAttributeFromNode("base",restriction);
         if(baseName == null)
         {
            throw new Error("A complexContent restriction must declare a base type.");
         }
         var baseType:QName = schemaManager.getQNameForPrefixedName(baseName,restriction);
         var childDefinitions:XMLList = restriction.elements();
         var children:XMLList = parent.elements();
         for each(childDefinition in childDefinitions)
         {
            if(childDefinition.name() == constants.sequenceQName)
            {
               this.encodeSequence(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               this.encodeGroupReference(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.allQName)
            {
               this.encodeAll(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               this.encodeChoice(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.attributeQName)
            {
               this.encodeAttribute(childDefinition,parent,name,value,restriction);
            }
            else if(childDefinition.name() == constants.attributeGroupQName)
            {
               this.encodeAttributeGroup(childDefinition,parent,name,value,restriction);
            }
            else if(childDefinition.name() == constants.anyAttributeQName)
            {
               this.encodeAnyAttribute(childDefinition,parent,name,value,restriction);
            }
         }
         parent.setChildren(children);
      }
      
      public function encodeComplexType(definition:XML, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var childDefinition:XML = null;
         var childElements:XMLList = definition.elements();
         var children:XMLList = new XMLList();
         for each(childDefinition in childElements)
         {
            if(childDefinition.name() == constants.sequenceQName)
            {
               this.encodeSequence(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.simpleContentQName)
            {
               this.encodeSimpleContent(childDefinition,parent,name,value,restriction);
            }
            else if(childDefinition.name() == constants.complexContentQName)
            {
               this.encodeComplexContent(childDefinition,parent,name,value);
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               this.encodeGroupReference(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.allQName)
            {
               this.encodeAll(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               this.encodeChoice(childDefinition,children,name,value);
            }
            else if(childDefinition.name() == constants.attributeQName)
            {
               this.encodeAttribute(childDefinition,parent,name,value,restriction);
            }
            else if(childDefinition.name() == constants.attributeGroupQName)
            {
               this.encodeAttributeGroup(childDefinition,parent,name,value,restriction);
            }
            else if(childDefinition.name() == constants.anyAttributeQName)
            {
               this.encodeAnyAttribute(childDefinition,parent,name,value,restriction);
            }
         }
         this.setValue(parent,children);
      }
      
      public function encodeGroupElement(definition:XML, siblings:XMLList, name:QName, value:*, isRequired:Boolean = true) : Boolean
      {
         var ref:QName = null;
         var encodedElement:XML = null;
         var valueOccurence:uint = 0;
         var iter:TypeIterator = null;
         var i:uint = 0;
         var item:* = undefined;
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(maxOccurs == 0)
         {
            return true;
         }
         isRequired &&= minOccurs > 0;
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.elementTypeQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve element definition for ref \'" + ref + "\'");
            }
         }
         var elementName:String = definition.@name.toString();
         var elementQName:QName = schemaManager.getQNameForElement(elementName,getAttributeFromNode("form",definition));
         var elementValue:* = this.getValue(value,elementQName);
         if(elementValue == null)
         {
            encodedElement = this.encodeElementTopLevel(definition,elementQName,elementValue);
            if(encodedElement != null)
            {
               this.appendValue(siblings,encodedElement);
            }
            if(ref != null)
            {
               schemaManager.releaseScope();
            }
            if(isRequired && encodedElement == null)
            {
               return false;
            }
            return true;
         }
         if(maxOccurs == 1)
         {
            encodedElement = this.encodeElementTopLevel(definition,elementQName,elementValue);
            if(encodedElement != null)
            {
               this.appendValue(siblings,encodedElement);
            }
         }
         else if(maxOccurs > 1)
         {
            valueOccurence = getValueOccurence(elementValue);
            if(valueOccurence < minOccurs)
            {
               throw new Error("Value supplied for element \'" + elementQName + "\' occurs " + valueOccurence + " times which falls short of minOccurs " + minOccurs + ".");
            }
            if(valueOccurence > maxOccurs)
            {
               throw new Error("Value supplied for element of type \'" + elementQName + "\' occurs " + valueOccurence + " times which exceeds maxOccurs " + maxOccurs + ".");
            }
            if(!TypeIterator.isIterable(elementValue))
            {
               elementValue = [elementValue];
            }
            iter = new TypeIterator(elementValue);
            i = 0;
            while(i < maxOccurs && i < valueOccurence)
            {
               if(iter.hasNext())
               {
                  item = iter.next();
               }
               else if(i > minOccurs)
               {
                  break;
               }
               encodedElement = this.encodeElementTopLevel(definition,elementQName,item);
               if(encodedElement == null)
               {
                  encodedElement = this.createElement(elementQName);
                  this.setValue(encodedElement,null);
               }
               this.appendValue(siblings,encodedElement);
               i++;
            }
         }
         if(ref != null)
         {
            schemaManager.releaseScope();
         }
         return true;
      }
      
      public function encodeElementTopLevel(definition:XML, elementQName:QName, value:*) : XML
      {
         var typeQName:QName = null;
         var typeDefinition:XML = null;
         var element:XML = this.encodeXSINil(definition,elementQName,value);
         if(element != null)
         {
            return element;
         }
         if(value == null)
         {
            return null;
         }
         element = this.createElement(elementQName);
         var typeAttribute:String = getAttributeFromNode("type",definition);
         if(typeAttribute != null)
         {
            typeQName = schemaManager.getQNameForPrefixedName(typeAttribute,definition);
            this.encodeType(typeQName,element,elementQName,value);
         }
         else if(definition != null && definition.hasComplexContent())
         {
            typeDefinition = getSingleElementFromNode(definition,constants.complexTypeQName,constants.simpleTypeQName);
            if(typeDefinition.name() == constants.complexTypeQName)
            {
               this.encodeComplexType(typeDefinition,element,elementQName,value);
            }
            else if(typeDefinition.name() == constants.simpleTypeQName)
            {
               this.encodeSimpleType(typeDefinition,element,elementQName,value);
            }
         }
         else
         {
            this.encodeType(constants.anyTypeQName,element,elementQName,value);
         }
         return element;
      }
      
      public function encodeGroupReference(definition:XML, parent:XMLList, name:QName, value:*, isRequired:Boolean = true) : Boolean
      {
         var ref:QName = null;
         var childDefinition:XML = null;
         if(definition.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(definition.@ref,definition,true);
            definition = schemaManager.getNamedDefinition(ref,constants.groupQName);
            if(definition == null)
            {
               throw new Error("Cannot resolve group definition for \'" + ref + "\'");
            }
            var groupElements:XMLList = definition.elements();
            var groupSatisfied:Boolean = false;
            for each(childDefinition in groupElements)
            {
               if(childDefinition.name() == constants.sequenceQName)
               {
                  groupSatisfied = this.encodeSequence(childDefinition,parent,name,value,isRequired);
               }
               else if(childDefinition.name() == constants.allQName)
               {
                  groupSatisfied = this.encodeAll(childDefinition,parent,name,value,isRequired);
               }
               else if(childDefinition.name() == constants.choiceQName)
               {
                  groupSatisfied = this.encodeChoice(childDefinition,parent,name,value,isRequired);
               }
            }
            schemaManager.releaseScope();
            return groupSatisfied;
         }
         throw new Error("A group reference element must have the ref attribute");
      }
      
      public function encodeSequence(definition:XML, siblings:XMLList, name:QName, value:*, isRequired:Boolean = true) : Boolean
      {
         var childDefinition:XML = null;
         var maxOccurs:uint = getMaxOccurs(definition);
         var minOccurs:uint = getMinOccurs(definition);
         if(maxOccurs == 0)
         {
            return true;
         }
         if(value == null && minOccurs == 0)
         {
            return true;
         }
         var sequenceElements:XMLList = definition.elements();
         var requireChild:Boolean = isRequired && minOccurs > 0;
         var sequenceSatisfied:Boolean = true;
         for each(childDefinition in sequenceElements)
         {
            sequenceSatisfied = false;
            if(childDefinition.name() == constants.elementTypeQName)
            {
               if(!this.encodeGroupElement(childDefinition,siblings,name,value,isRequired))
               {
                  break;
               }
            }
            else if(childDefinition.name() == constants.groupQName)
            {
               if(!this.encodeGroupReference(childDefinition,siblings,name,value,isRequired))
               {
                  break;
               }
            }
            else if(childDefinition.name() == constants.choiceQName)
            {
               if(!this.encodeChoice(childDefinition,siblings,name,value,isRequired))
               {
                  break;
               }
            }
            else if(childDefinition.name() == constants.sequenceQName)
            {
               if(!this.encodeSequence(childDefinition,siblings,name,value,isRequired))
               {
                  break;
               }
            }
            else if(childDefinition.name() == constants.anyQName)
            {
               if(!this.encodeAnyElement(childDefinition,siblings,name,value,isRequired))
               {
                  break;
               }
            }
            sequenceSatisfied = true;
         }
         return sequenceSatisfied || !isRequired;
      }
      
      public function encodeSimpleContent(definition:XML, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var baseName:String = null;
         var baseType:QName = null;
         var simpleValue:* = undefined;
         var baseDefinition:XML = null;
         var extensions:XMLList = null;
         var extensionChild:XML = null;
         var childDefinition:XML = getSingleElementFromNode(definition,constants.extensionQName,constants.restrictionQName);
         if(childDefinition != null)
         {
            baseName = getAttributeFromNode("base",childDefinition);
            if(baseName == null)
            {
               throw new Error("A simpleContent extension or restriction must declare a base type.");
            }
            baseType = schemaManager.getQNameForPrefixedName(baseName,childDefinition);
            if(!isBuiltInType(baseType))
            {
               baseDefinition = schemaManager.getNamedDefinition(baseType,constants.complexTypeQName,constants.simpleTypeQName);
               if(baseDefinition == null)
               {
                  throw new Error("Cannot find base type definition \'" + baseType + "\'");
               }
               schemaManager.releaseScope();
            }
            if(childDefinition.name() == constants.extensionQName)
            {
               if(isBuiltInType(baseType))
               {
                  simpleValue = this.getSimpleValue(value,name);
                  this.setValue(parent,schemaManager.marshall(simpleValue,baseType,restriction));
               }
               else
               {
                  this.encodeType(baseType,parent,value,restriction);
               }
               extensions = childDefinition.elements();
               for each(extensionChild in extensions)
               {
                  if(extensionChild.name() == constants.attributeQName)
                  {
                     this.encodeAttribute(extensionChild,parent,name,value,restriction);
                  }
                  else if(extensionChild.name() == constants.attributeGroupQName)
                  {
                     this.encodeAttributeGroup(extensionChild,parent,name,value,restriction);
                  }
                  else if(extensionChild.name() == constants.anyAttributeQName)
                  {
                     this.encodeAnyAttribute(extensionChild,parent,name,value,restriction);
                  }
               }
            }
            else if(childDefinition.name() == constants.restrictionQName)
            {
               simpleValue = this.getSimpleValue(value,name);
               this.encodeSimpleRestriction(childDefinition,parent,name,simpleValue);
            }
         }
      }
      
      public function encodeSimpleList(definition:XML, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var itemTypeQName:QName = null;
         var itemDefinition:XML = null;
         var item:* = undefined;
         var tempElement:* = undefined;
         var itemTypeAttribute:String = definition.@itemType;
         if(itemTypeAttribute != "")
         {
            itemTypeQName = schemaManager.getQNameForPrefixedName(itemTypeAttribute,definition);
         }
         else
         {
            itemDefinition = getSingleElementFromNode(definition,constants.simpleTypeQName);
         }
         var listValue:String = "";
         if(!TypeIterator.isIterable(value))
         {
            value = [value];
         }
         var iter:TypeIterator = new TypeIterator(value);
         while(iter.hasNext())
         {
            item = iter.next();
            tempElement = <temp/>;
            if(item != null)
            {
               if(itemTypeQName != null)
               {
                  this.encodeType(itemTypeQName,tempElement,name,item,restriction);
               }
               else
               {
                  this.encodeSimpleType(itemDefinition,tempElement,name,item,restriction);
               }
               listValue = listValue.concat(tempElement.toString());
               if(iter.hasNext())
               {
                  listValue = listValue.concat(" ");
               }
            }
         }
         this.setValue(parent,listValue);
      }
      
      public function encodeSimpleRestriction(restriction:XML, parent:XML, name:QName, value:*) : void
      {
         var baseName:String = null;
         var baseType:QName = null;
         var simpleTypeDefinition:XML = getSingleElementFromNode(restriction,constants.simpleTypeQName);
         if(simpleTypeDefinition != null)
         {
            this.encodeSimpleType(simpleTypeDefinition,parent,name,value,restriction);
         }
         else
         {
            baseName = getAttributeFromNode("base",restriction);
            baseType = schemaManager.getQNameForPrefixedName(baseName,restriction);
            this.encodeType(baseType,parent,name,value,restriction);
         }
      }
      
      public function encodeSimpleType(definition:XML, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var definitionChild:XML = getSingleElementFromNode(definition,constants.restrictionQName,constants.listQName,constants.unionQName);
         if(definitionChild.name() == constants.restrictionQName)
         {
            this.encodeSimpleRestriction(definitionChild,parent,name,value);
         }
         else if(definitionChild.name() == constants.listQName)
         {
            this.encodeSimpleList(definitionChild,parent,name,value,restriction);
         }
         else if(definitionChild.name() == constants.listQName)
         {
            this.encodeSimpleUnion(definitionChild,parent,name,value,restriction);
         }
      }
      
      public function encodeSimpleUnion(definition:XML, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var type:QName = null;
         var args:* = undefined;
         var prefixedName:String = null;
         var simpleType:QName = null;
         var memberList:String = getAttributeFromNode("memberTypes",definition);
         var memberArray:Array = memberList.split(" ");
         for(var i:int = 0; i < memberArray.length; i++)
         {
            prefixedName = memberArray[i];
            simpleType = schemaManager.getQNameForPrefixedName(prefixedName,definition);
            if(!isBuiltInType(simpleType))
            {
               args = this.getValue(value,simpleType);
               if(args !== undefined)
               {
                  type = simpleType;
                  break;
               }
            }
         }
         if(!type)
         {
            type = schemaManager.schemaDatatypes.stringQName;
         }
         this.setValue(parent,schemaManager.marshall(value,type,restriction));
      }
      
      public function encodeType(type:QName, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var children:XMLList = null;
         var definitionType:QName = null;
         var xsiType:QName = this.getXSIType(value);
         if(xsiType != null)
         {
            type = xsiType;
         }
         var definition:XML = schemaManager.getNamedDefinition(type,constants.complexTypeQName,constants.simpleTypeQName);
         if(isBuiltInType(type))
         {
            if(type == constants.anyTypeQName && !this.isSimpleValue(value))
            {
               children = new XMLList();
               this.encodeAnyElement(definition,children,name,value);
               this.setValue(parent,children);
            }
            else
            {
               this.setValue(parent,schemaManager.marshall(value,type,restriction));
            }
            this.deriveXSIType(parent,type,value);
         }
         else
         {
            if(definition == null)
            {
               throw new Error("Cannot find definition for type \'" + type + "\'");
            }
            definitionType = definition.name() as QName;
            if(definitionType == constants.complexTypeQName)
            {
               this.encodeComplexType(definition,parent,name,value,restriction);
            }
            else
            {
               if(definitionType != constants.simpleTypeQName)
               {
                  throw new Error("Invalid type definition " + definitionType);
               }
               this.encodeSimpleType(definition,parent,name,value,restriction);
            }
         }
         if(definition != null)
         {
            schemaManager.releaseScope();
         }
      }
      
      public function encodeXSINil(definition:XML, name:QName, value:*, isRequired:Boolean = true) : XML
      {
         var item:XML = null;
         var nillable:Boolean = true;
         if(this.strictNillability)
         {
            if(definition != null)
            {
               nillable = definition.@nillable.toString() == "true" ? true : false;
            }
            else
            {
               nillable = false;
            }
         }
         var fixedValue:String = getAttributeFromNode("fixed",definition);
         if(!(this.strictNillability && nillable) && fixedValue != null)
         {
            item = this.createElement(name);
            this.setValue(item,schemaManager.marshall(fixedValue,schemaManager.schemaDatatypes.stringQName));
            return item;
         }
         if(value != null)
         {
            return null;
         }
         var defaultValue:String = getAttributeFromNode("default",definition);
         if(value == null && defaultValue != null)
         {
            item = this.createElement(name);
            this.setValue(item,schemaManager.marshall(defaultValue,schemaManager.schemaDatatypes.stringQName));
            return item;
         }
         if(nillable && value === null && isRequired == true)
         {
            item = this.createElement(name);
            this.setValue(item,null);
            return item;
         }
         return null;
      }
      
      public function getAttribute(parent:*, name:*) : *
      {
         return this.getValue(parent,name);
      }
      
      public function hasAttribute(parent:*, name:*) : Boolean
      {
         return this.getAttribute(parent,name) !== undefined;
      }
      
      public function setAttribute(parent:XML, name:*, value:*) : void
      {
         if(value != null)
         {
            parent[name] = value.toString();
         }
      }
      
      public function getProperties(value:*) : Array
      {
         var classInfo:Object = ObjectUtil.getClassInfo(value as Object,null,{"includeReadOnly":false});
         return classInfo.properties;
      }
      
      public function createElement(name:*) : XML
      {
         var element:XML = null;
         var elementName:QName = null;
         var prefix:String = null;
         var ns:Namespace = null;
         if(name is QName)
         {
            elementName = name as QName;
         }
         else
         {
            elementName = new QName("",name.toString());
         }
         element = new XML("<" + elementName.localName + "/>");
         if(elementName.uri != null && elementName.uri.length > 0)
         {
            prefix = schemaManager.getOrCreatePrefix(elementName.uri);
            ns = new Namespace(prefix,elementName.uri);
            element.setNamespace(ns);
         }
         return element;
      }
      
      public function getSimpleValue(parent:*, name:*) : *
      {
         var simpleValue:* = this.getValue(parent,name);
         if(simpleValue === undefined)
         {
            simpleValue = this.getValue(parent,"_value");
         }
         return simpleValue;
      }
      
      public function isSimpleValue(value:*) : Boolean
      {
         if(value is String || value is Number || value is Boolean || value is Date || value is int || value is uint || value is ByteArray)
         {
            return true;
         }
         return false;
      }
      
      public function getValue(parent:*, name:*) : *
      {
         var value:* = undefined;
         var node:XMLList = null;
         if(parent is XML || parent is XMLList)
         {
            node = parent[name];
            if(node.length() > 0)
            {
               value = node;
            }
         }
         else if(TypeIterator.isIterable(parent))
         {
            if(Boolean(parent.hasOwnProperty(name)) && parent[name] !== undefined)
            {
               value = this.resolveNamedProperty(parent,name);
            }
            else
            {
               value = parent;
            }
         }
         else if(!this.isSimpleValue(parent))
         {
            if(name is QName)
            {
               name = QName(name).localName;
            }
            value = this.resolveNamedProperty(parent,name);
         }
         else
         {
            value = parent;
         }
         return value;
      }
      
      public function hasValue(parent:*, name:*) : Boolean
      {
         return this.getValue(parent,name) !== undefined;
      }
      
      public function containsNodeByName(list:XMLList, name:QName, strict:Boolean = false) : Boolean
      {
         var node:XML = null;
         var currentURI:String = schemaManager.currentSchema.targetNamespace.uri;
         for each(node in list)
         {
            if(strict || name.uri != "" && name.uri != null)
            {
               if(node.name().uri == "" && currentURI == name.uri)
               {
                  if(node.name().localName == name.localName)
                  {
                     return true;
                  }
               }
               else if(node.name() == name)
               {
                  return true;
               }
            }
            else if(node.name().localName == name.localName)
            {
               return true;
            }
         }
         return false;
      }
      
      public function resolveNamedProperty(parent:*, name:*) : *
      {
         var value:* = undefined;
         var fallbackName:String = null;
         if(!this.isSimpleValue(parent))
         {
            try
            {
               value = parent[name];
               if(value === undefined)
               {
                  fallbackName = "_" + name.toString();
               }
            }
            catch(e:Error)
            {
               fallbackName = "_" + name.toString();
            }
            if(fallbackName != null && Boolean(parent.hasOwnProperty(fallbackName)))
            {
               value = parent[fallbackName];
            }
         }
         return value;
      }
      
      public function setValue(parent:*, value:*) : void
      {
         var currentChild:XML = null;
         if(value !== undefined)
         {
            if(parent is XML)
            {
               currentChild = parent as XML;
            }
            else if(parent is XMLList && parent.length() > 0)
            {
               currentChild = parent[parent.length() - 1];
            }
            if(currentChild != null)
            {
               if(value === null)
               {
                  currentChild[schemaManager.schemaConstants.nilQName] = "true";
                  currentChild.addNamespace(constants.xsiNamespace);
               }
               else if(value is XML || value is XMLList)
               {
                  currentChild.appendChild(value);
               }
               else if(value !== undefined)
               {
                  currentChild.appendChild(this.xmlSpecialCharsFilter(Object(value)));
               }
            }
         }
      }
      
      public function appendValue(parent:XMLList, value:*) : void
      {
         parent[parent.length()] = value;
      }
      
      protected function getXSIType(value:*) : QName
      {
         var xsiType:QName = null;
         if(value != null)
         {
            if(value is ObjectProxy && value.object_proxy::type != null)
            {
               xsiType = value.object_proxy::type;
            }
            else if(value is IXMLSchemaInstance && IXMLSchemaInstance(value).xsiType != null)
            {
               xsiType = IXMLSchemaInstance(value).xsiType;
            }
         }
         return xsiType;
      }
      
      protected function setXSIType(parent:XML, type:QName) : void
      {
         var namespaceURI:String = type.uri;
         var prefix:String = schemaManager.getOrCreatePrefix(namespaceURI);
         var prefixNamespace:Namespace = new Namespace(prefix,namespaceURI);
         parent.addNamespace(prefixNamespace);
         parent[constants.getXSIToken(constants.typeAttrQName)] = prefix + ":" + type.localName;
      }
      
      protected function deriveXSIType(parent:XML, type:QName, value:*) : void
      {
      }
      
      private function escapeXML(value:Object) : String
      {
         var str:String = value.toString();
         if(this._escapeXMLChars)
         {
            str = str.replace(/&/g,"&amp;").replace(/</g,"&lt;");
         }
         return str;
      }
      
      public function get strictNillability() : Boolean
      {
         return this._strictNillability;
      }
      
      public function set strictNillability(strict:Boolean) : void
      {
         this._strictNillability = strict;
      }
      
      public function get xmlSpecialCharsFilter() : Function
      {
         return this._xmlSpecialCharsFilter;
      }
      
      public function set xmlSpecialCharsFilter(func:Function) : void
      {
         if(func != null)
         {
            this._xmlSpecialCharsFilter = func;
         }
         else
         {
            this._xmlSpecialCharsFilter = this.escapeXML;
         }
      }
   }
}

