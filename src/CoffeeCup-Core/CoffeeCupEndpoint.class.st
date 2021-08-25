Class {
	#name : #CoffeeCupEndpoint,
	#superclass : #Object,
	#instVars : [
		'namespace',
		'name',
		'path',
		'pathParameters',
		'queryParameters'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupEndpoint class >> namespace: aNamespace name: aSymbol [

	^ self new
		  setNamespace: aNamespace name: aSymbol;
		  yourself
]

{ #category : #deprecated }
CoffeeCupEndpoint >> _doesNotUnderstand: aMessage [

	| selector |
	selector := aMessage selector.

	^ selector isRestApiCall
		  ifTrue: [ 
			  self call: selector coffeeCupMethod with: (OrderedDictionary
					   newFromKeys: selector coffeeCupArguments
					   andValues: aMessage arguments) ]
		  ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #deprecated }
CoffeeCupEndpoint >> _parameter: parameter required: aBoolean default: defaultValue [

	parameters add: (CoffeeCupQueryParameter
			 key: parameter asCoffeeCupSelector
			 name: parameter
			 required: aBoolean
			 default: defaultValue)
]

{ #category : #accessing }
CoffeeCupEndpoint >> allParameters [

	^ namespace allParameters , pathParameters , queryParameters 
]

{ #category : #accessing }
CoffeeCupEndpoint >> allPathParameters [

	^ self allParameters select: #isPathParameter  
	
]

{ #category : #accessing }
CoffeeCupEndpoint >> allQueryParameters [

	^ self allParameters select: #isQueryParameter
]

{ #category : #private }
CoffeeCupEndpoint >> callWith: arguments [

	| mappedPath url request |
	mappedPath := self mappedPath: arguments.
	url := namespace baseUrl / mappedPath.

	(self mappedQueryParameters: arguments) keysAndValuesDo: [ :key :value | 
		url queryAt: key put: value ].

	request := ZnRequest
		           method: self method asCoffeeCupSelector asUppercase
		           url: url.

	^ namespace request: request
]

{ #category : #initialization }
CoffeeCupEndpoint >> initialize [

	super initialize.
	pathParameters  := Set new.
	queryParameters := Set new.
]

{ #category : #private }
CoffeeCupEndpoint >> mappedPath: arguments [

	^ self path format: (self mappedPathParameters: arguments)
]

{ #category : #private }
CoffeeCupEndpoint >> mappedPathParameters: arguments [

	| mapped |
	mapped := Dictionary new.
	self allParameters select: #isPathParameter thenDo: [ :parameter | 
		parameter isRequired
			ifTrue: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ]
					ifAbsent: [ 
						parameter default
							ifNotNil: [ :defaultValue | 
							mapped at: parameter name put: defaultValue ]
							ifNil: [ CoffeeCupError signalMissingArgument: parameter ] ] ]
			ifFalse: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ] ] ].
	^ mapped
]

{ #category : #private }
CoffeeCupEndpoint >> mappedQueryParameters: arguments [

	| mapped |
	mapped := Dictionary new.
	self allParameters select: #isQueryParameter thenDo: [ :parameter | 
		parameter isRequired
			ifTrue: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ]
					ifAbsent: [ 
						parameter default
							ifNotNil: [ :defaultValue | 
							mapped at: parameter name put: defaultValue ]
							ifNil: [ CoffeeCupError signalMissingArgument: parameter ] ] ]
			ifFalse: [ 
				arguments
					at: parameter key
					ifPresent: [ :argumentValue | 
					mapped at: parameter name put: argumentValue ] ] ].
	^ mapped
]

{ #category : #accessing }
CoffeeCupEndpoint >> method [

^#get
]

{ #category : #private }
CoffeeCupEndpoint >> parameter: aString [

	^ pathParameters  add: (CoffeeCupQueryParameter
			   key: aString asCoffeeCupSelector
			   name: aString)
]

{ #category : #accessing }
CoffeeCupEndpoint >> path [

	^ path ifNil: [ name asSymbol ]
]

{ #category : #accessing }
CoffeeCupEndpoint >> path: aString [

	path := aString.

	queryParameters := (path coffeeCupFormatParameters collect: [ 
		                    :pathParameter | 
		                    CoffeeCupPathParameter
			                    key: pathParameter asCoffeeCupSelector
			                    name: pathParameter ]) asSet
]

{ #category : #initialization }
CoffeeCupEndpoint >> setNamespace: aNamespace name: aSymbol [

	namespace := aNamespace.
	name := aSymbol.
	
]

{ #category : #configuration }
CoffeeCupEndpoint >> with: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ].
]
