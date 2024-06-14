function newSorcerer(name: string, ritual: string, cursedEnergy: number){
    
    type Sorcerer = {
        name: string,
        ritual: string,
        cursedEnergy: number
    };

    const sorcerer : Sorcerer = {
        name: name,
        ritual: ritual,
        cursedEnergy: cursedEnergy
    };


    console.log(sorcerer);

}


newSorcerer("itadori Yuji", "Shrine", 2000);
newSorcerer("Megumi Fushiguro", "Ten shadows", 2000);