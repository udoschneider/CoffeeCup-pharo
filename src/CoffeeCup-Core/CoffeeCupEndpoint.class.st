Class {
	#name : #CoffeeCupEndpoint,
	#superclass : #CoffeeCupPathObject,
	#instVars : [
		'namespace',
		'name'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupEndpoint class >> namespace: aNamespace name: aSymbol [

	^ self new
		  setNamespace: aNamespace name: aSymbol;
		  yourself
]

{ #category : #accessing }
CoffeeCupEndpoint >> allParameters [

	^ namespace allParameters , pathParameters, queryParameters
]

{ #category : #accessing }
CoffeeCupEndpoint >> baseUrl [

	^ namespace baseUrl
]

{ #category : #private }
CoffeeCupEndpoint >> callWith: arguments [

	| mappedPath url request |
	mappedPath := self mappedPath: arguments.
	url := self baseUrl / mappedPath.

	(self mappedQueryParameters: arguments) keysAndValuesDo: [ :key :value | 
		url queryAt: key put: value ].

	request := ZnRequest
		           method: self method asCoffeeCupSelector asUppercase
		           url: url.

	^ self request: request
]

{ #category : #accessing }
CoffeeCupEndpoint >> fullPath [

	^ namespace fullPath , '/' , self path
]

{ #category : #private }
CoffeeCupEndpoint >> mappedPath: arguments [

	^ self fullPath format: (self mappedPathParameters: arguments)
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

{ #category : #accessing }
CoffeeCupEndpoint >> name [

	^ name
]

{ #category : #accessing }
CoffeeCupEndpoint >> namespace [

	^ namespace
]

{ #category : #configuration }
CoffeeCupEndpoint >> parameter: aSymbolOrString [

	^ queryParameters  add: (CoffeeCupQueryParameter
			   key: aSymbolOrString asCoffeeCupSelector
			   name: aSymbolOrString)
]

{ #category : #configuration }
CoffeeCupEndpoint >> parameter: aSymbolOrString do: aBlock [
^(self parameter: aSymbolOrString ) do: aBlock
]

{ #category : #accessing }
CoffeeCupEndpoint >> path [

	^ path ifNil: [ name asString ]
]

{ #category : #private }
CoffeeCupEndpoint >> request: request [

	^ namespace request: request
]

{ #category : #initialization }
CoffeeCupEndpoint >> setNamespace: aNamespace name: aSymbol [

	namespace := aNamespace.
	name := aSymbol.
	
]
