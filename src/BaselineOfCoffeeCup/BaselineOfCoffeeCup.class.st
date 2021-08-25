Class {
	#name : #BaselineOfCoffeeCup,
	#superclass : #BaselineOf,
	#category : #BaselineOfCoffeeCup
}

{ #category : #baselines }
BaselineOfCoffeeCup >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec package: #'CofeeCup-Core'.
		spec
			package: #'CoffeCup-Tests'
			with: [ spec requires: #( #'CofeeCup-Core' ) ];
			group: 'default' with: #( core tests );
			group: 'core' with: #( #'CofeeCup-Core' );
			group: 'tests' with: #( #'CofeeCup-tests' ) ]
]
