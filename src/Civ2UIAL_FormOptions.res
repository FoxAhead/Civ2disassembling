        ��  ��                    4   ��
 F O R M O P T I O N S       0           <?xml version="1.0"?>
<options>
	<section name="UI Additions" description="User Interface Additions">
		<boolean key="UIAEnable" name="Enable" description="Enable patches from User Interface Additions"/>
	</section>
	<section name="civ2patch" description="Some fixes and enhacements from civ2patch project">
		<boolean key="civ2patchEnable" name="Enable" description="Enable patches from civ2patch">
			<boolean key="HostileAiOn" name="Hostile AI" description="When enabled, AI will not be unreasonably hostile to the player."/>
			<boolean key="RetirementYearOn" name="Retirement year" description="When enabled, allow the retirement year to be modified.">
				<integer key="RetirementYear" name="Warning year"/>
				<integer key="RetirementWarningYear" name="Retirement year"/>
			</boolean>
			<boolean key="PopulationLimitOn" name="Population limit" description="When enabled, allow the population limit to be modified.">
				<integer key="PopulationLimit" name="Population limit"/>
			</boolean>
			<boolean key="GoldLimitOn" name="Gold limit" description="When enabled, allow the gold limit to be modified.">
				<integer key="GoldLimit" name="Gold limit"/>
			</boolean>
			<boolean key="MapSizeLimitOn" name="Map size limit" description="When enabled, allow the number of map tiles limit to be modified.">
				<integer key="MapXLimit" name="Map X limit"/>
				<integer key="MapYLimit" name="Map Y limit"/>
				<integer key="MapSizeLimit" name="Map size limit"/>
			</boolean>
		</boolean>
	</section>
</options>