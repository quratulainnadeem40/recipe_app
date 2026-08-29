import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

class PakistaniRecipesData {
  static final List<Map<String, dynamic>> rawPakistaniRecipes = _buildAllPakistaniRecipes();

  static List<Map<String, dynamic>> _buildAllPakistaniRecipes() {
    final List<Map<String, dynamic>> list = [];

    void addRecipe({
      required String id,
      required String name,
      required String category,
      required String image,
      required String tags,
      required String difficulty,
      required String prepTime,
      required String rating,
      required String reviews,
      required List<String> steps,
      required List<Map<String, String>> ingredients,
      String youtube = 'https://www.youtube.com/results?search_query=pakistani+recipes',
    }) {
      final Map<String, dynamic> map = {
        'idMeal': id,
        'strMeal': name,
        'strCategory': category,
        'strArea': 'Pakistani',
        'strMealThumb': image,
        'strTags': tags,
        'strYoutube': youtube,
        'difficulty': difficulty,
        'prepTime': prepTime,
        'rating': rating,
        'reviews': reviews,
        'strInstructions': steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\r\n'),
      };

      for (int i = 0; i < ingredients.length && i < 20; i++) {
        map['strIngredient${i + 1}'] = ingredients[i]['name'] ?? '';
        map['strMeasure${i + 1}'] = ingredients[i]['measure'] ?? '';
      }

      list.add(map);
    }

    // =========================================================================
    // 1. BIRYANI & RICE SPECIALS (Dishes 1 - 15)
    // =========================================================================
    addRecipe(
      id: 'pak_101',
      name: 'Special Karachi Chicken Dum Biryani',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=800&auto=format&fit=crop',
      tags: 'Biryani,Rice,Spicy,Karachi,Chicken',
      difficulty: 'Medium',
      prepTime: '45',
      rating: '4.9',
      reviews: '1850',
      steps: [
        'Marinate chicken with yogurt, ginger-garlic, biryani masala, red chilli, and fried onions for 30 minutes.',
        'Heat oil in a pot, add whole garam masala and marinated chicken with chopped tomatoes; cook until oil separates.',
        'Boil aged basmati rice with whole spices, mint, and salt until 70% done, then strain.',
        'Layer chicken masala and fragrant rice; top with fried onions, mint, coriander, and saffron kewra milk.',
        'Cover tightly with foil and simmer on low dum heat for 15-20 minutes. Serve hot with raita.'
      ],
      ingredients: [
        {'name': 'Basmati Rice', 'measure': '750g'},
        {'name': 'Chicken Bone-in', 'measure': '1 kg'},
        {'name': 'Yogurt', 'measure': '1 cup'},
        {'name': 'Fried Onions (Birista)', 'measure': '1.5 cups'},
        {'name': 'Biryani Masala', 'measure': '2.5 tbsp'},
        {'name': 'Tomatoes', 'measure': '3 chopped'},
        {'name': 'Mint & Coriander', 'measure': '1 cup'},
        {'name': 'Ghee / Cooking Oil', 'measure': '1/2 cup'},
      ],
    );

    addRecipe(
      id: 'pak_102',
      name: 'Sindhi Mutton Biryani',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?q=80&w=800&auto=format&fit=crop',
      tags: 'Biryani,Sindhi,Mutton,Spicy,AluBukhara',
      difficulty: 'Hard',
      prepTime: '55',
      rating: '5.0',
      reviews: '1420',
      steps: [
        'Cook tender mutton with chopped tomatoes, Sindhi biryani spices, dried plums (alu bukhara), and yogurt.',
        'Add whole fried potatoes to the masala gravy and cook until soft.',
        'Boil basmati rice with cloves, cardamom, and salt until 3/4 cooked.',
        'Layer mutton gravy with yellow food color, sliced lemons, green chillies, and boiled rice.',
        'Simmer on dum for 20 minutes on low heat. Mix gently before serving with chilled cucumber raita.'
      ],
      ingredients: [
        {'name': 'Mutton with Bone', 'measure': '1 kg'},
        {'name': 'Basmati Rice', 'measure': '750g'},
        {'name': 'Potatoes (halved)', 'measure': '3 medium'},
        {'name': 'Dried Plums (Aloo Bukhara)', 'measure': '10 pieces'},
        {'name': 'Yogurt', 'measure': '1 cup'},
        {'name': 'Sindhi Biryani Masala', 'measure': '3 tbsp'},
        {'name': 'Lemon & Green Chillies', 'measure': 'For layers'},
      ],
    );

    addRecipe(
      id: 'pak_103',
      name: 'Mutton Yakhni Pulao',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?q=80&w=800&auto=format&fit=crop',
      tags: 'Pulao,Yakhni,Mutton,Aromatic,Degi',
      difficulty: 'Medium',
      prepTime: '45',
      rating: '4.9',
      reviews: '1120',
      steps: [
        'Boil mutton with whole fennel, coriander seeds, garlic, ginger, and garam masala in a cloth bouquet to make fragrant broth (yakhni).',
        'Strain broth and reserve meat pieces.',
        'In a heavy pot, heat ghee and lightly fry onions with green chillies, ginger-garlic paste, and yogurt.',
        'Add meat, soaked basmati rice, and strained yakhni broth.',
        'Cook on high flame until water level drops, then seal and simmer on dum for 15 minutes.'
      ],
      ingredients: [
        {'name': 'Mutton Bone-in', 'measure': '800g'},
        {'name': 'Aged Basmati Rice', 'measure': '750g'},
        {'name': 'Fennel & Coriander Seeds', 'measure': '2 tbsp each'},
        {'name': 'Yogurt', 'measure': '1/2 cup'},
        {'name': 'Desi Ghee', 'measure': '1/2 cup'},
        {'name': 'Whole Garam Masala', 'measure': '1.5 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_104',
      name: 'Beef Degi Pulao',
      category: 'Beef',
      image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=800&auto=format&fit=crop',
      tags: 'Pulao,Beef,Degi,Lahore,Traditional',
      difficulty: 'Hard',
      prepTime: '60',
      rating: '4.8',
      reviews: '890',
      steps: [
        'Prepare rich beef stock by boiling beef cuts with whole spices and onions for 1 hour.',
        'Fry sliced onions in ghee until golden brown; remove half for garnish.',
        'Sauté beef with yogurt, cumin, black pepper, and ginger paste.',
        'Add long grain basmati rice and boiling beef broth; adjust salt.',
        'Cover tightly and steam on dum for 18 minutes until rice grains are fluffy and separate.'
      ],
      ingredients: [
        {'name': 'Beef Chuck Cuts', 'measure': '1 kg'},
        {'name': 'Basmati Rice', 'measure': '800g'},
        {'name': 'Desi Ghee', 'measure': '3/4 cup'},
        {'name': 'Onions Sliced', 'measure': '3 medium'},
        {'name': 'Black Cumin (Shahi Jeera)', 'measure': '1 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_105',
      name: 'Peshawari Kabuli Pulao',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?q=80&w=800&auto=format&fit=crop',
      tags: 'Kabuli,Pulao,Peshawar,Carrot,Raisin,DryFruit',
      difficulty: 'Medium',
      prepTime: '50',
      rating: '4.9',
      reviews: '970',
      steps: [
        'Caramelize sliced carrots and black seedless raisins in sugar and butter; set aside.',
        'Cook tender mutton shanks with onions, cardamom, and water to make fragrant stock.',
        'Add soaked sella basmati rice into the meat stock and cook until liquid absorbs.',
        'Top the rice with mutton shanks and caramelized carrot-raisin garnish.',
        'Dum cook on low flame for 20 minutes and serve warm with salad.'
      ],
      ingredients: [
        {'name': 'Mutton Shanks', 'measure': '1 kg'},
        {'name': 'Sella / Basmati Rice', 'measure': '750g'},
        {'name': 'Julienned Carrots', 'measure': '2 cups'},
        {'name': 'Black Raisins (Kishmish)', 'measure': '1 cup'},
        {'name': 'Sugar & Butter', 'measure': '2 tbsp each'},
        {'name': 'Cardamom Powder', 'measure': '1 tsp'},
      ],
    );

    addRecipe(
      id: 'pak_106',
      name: 'Chicken Tikka Biryani',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=800&auto=format&fit=crop',
      tags: 'Tikka,Biryani,BBQ,Smoky,Spicy',
      difficulty: 'Medium',
      prepTime: '45',
      rating: '4.9',
      reviews: '1350',
      steps: [
        'Marinate chicken chunks with tikka masala and grill/pan-fry until charred; give charcoal smoke.',
        'Prepare spicy tomato-yogurt gravy in a separate pot with biryani spices.',
        'Mix grilled smoky chicken tikka pieces into the gravy.',
        'Layer with 70% boiled aromatic basmati rice, mint, coriander, and yellow food color.',
        'Dum cook for 15 minutes. Serve with smoky mint raita.'
      ],
      ingredients: [
        {'name': 'Boneless Chicken Cubes', 'measure': '800g'},
        {'name': 'Basmati Rice', 'measure': '700g'},
        {'name': 'Tikka Spice Blend', 'measure': '3 tbsp'},
        {'name': 'Yogurt & Lemon Juice', 'measure': '1/2 cup + 2 tbsp'},
        {'name': 'Charcoal Piece for Smoke', 'measure': '1'},
      ],
    );

    addRecipe(
      id: 'pak_107',
      name: 'Matka Dum Biryani',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=800&auto=format&fit=crop',
      tags: 'Matka,ClayPot,Biryani,Traditional,Dum',
      difficulty: 'Hard',
      prepTime: '50',
      rating: '4.8',
      reviews: '670',
      steps: [
        'Cook spiced chicken korma with fresh herbs and aromatics.',
        'Fill traditional clay earthen pot (matka) with alternating layers of chicken and parboiled rice.',
        'Seal the matka mouth with dough and earthen lid.',
        'Place on direct embers or stove flame for 20 minutes to infuse the earthy clay aroma.',
        'Break open dough seal hot at the table and enjoy.'
      ],
      ingredients: [
        {'name': 'Chicken Pieces', 'measure': '750g'},
        {'name': 'Basmati Rice', 'measure': '600g'},
        {'name': 'Clay Pot (Matka)', 'measure': '1 large'},
        {'name': 'Kneaded Dough for Seal', 'measure': '1 cup'},
      ],
    );

    addRecipe(
      id: 'pak_108',
      name: 'Desi Chana Pulao',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?q=80&w=800&auto=format&fit=crop',
      tags: 'Chana,Pulao,Vegetarian,Healthy,Rice',
      difficulty: 'Easy',
      prepTime: '30',
      rating: '4.7',
      reviews: '580',
      steps: [
        'Boil white chickpeas (kabuli chana) until tender and retain chickpea broth.',
        'Sauté sliced onions, cumin, green chillies, and ginger-garlic paste in ghee.',
        'Add boiled chickpeas, yogurt, black pepper, and garam masala.',
        'Pour in soaked basmati rice with the chickpea broth.',
        'Simmer until liquid reduces, then steam on dum for 12 minutes.'
      ],
      ingredients: [
        {'name': 'Boiled Chickpeas (Chana)', 'measure': '2 cups'},
        {'name': 'Basmati Rice', 'measure': '500g'},
        {'name': 'Onions & Green Chillies', 'measure': '2 sliced'},
        {'name': 'Desi Ghee', 'measure': '4 tbsp'},
        {'name': 'Garam Masala & Cumin', 'measure': '1 tbsp each'},
      ],
    );

    addRecipe(
      id: 'pak_109',
      name: 'Zafrani Shahi Zarda',
      category: 'Dessert',
      image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop',
      tags: 'Zarda,SweetRice,Saffron,Mithai,Dessert',
      difficulty: 'Easy',
      prepTime: '30',
      rating: '4.8',
      reviews: '810',
      steps: [
        'Boil sella rice with pure saffron strands and orange food color until 85% done; drain completely.',
        'In a pan, melt desi ghee with crushed cardamom and cloves.',
        'Add sugar and milk to create a rich sweet syrup (sheera).',
        'Add colored rice into the syrup and gently stir on medium heat.',
        'Top with ashrafi murabba, mini gulab jamun, khoya (mawa), and mixed nuts; steam on dum for 15 mins.'
      ],
      ingredients: [
        {'name': 'Sella Basmati Rice', 'measure': '500g'},
        {'name': 'Sugar', 'measure': '450g'},
        {'name': 'Desi Ghee', 'measure': '1/2 cup'},
        {'name': 'Khoya (Mawa) & Mini Gulab Jamun', 'measure': '1 cup'},
        {'name': 'Almonds, Pistachios & Saffron', 'measure': '1/2 cup'},
      ],
    );

    addRecipe(
      id: 'pak_110',
      name: 'Matar Pulao (Peas Rice)',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?q=80&w=800&auto=format&fit=crop',
      tags: 'Matar,Pulao,Vegetarian,Quick,Rice',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.7',
      reviews: '490',
      steps: [
        'Sauté sliced onions with cumin seeds, cinnamon, cloves, and ginger paste in ghee.',
        'Add fresh sweet green peas and stir-fry for 3 minutes.',
        'Add washed basmati rice, water, and salt.',
        'Cover and cook until water evaporates, then let it rest on low dum for 10 minutes.'
      ],
      ingredients: [
        {'name': 'Fresh Green Peas', 'measure': '1.5 cups'},
        {'name': 'Basmati Rice', 'measure': '500g'},
        {'name': 'Cumin Seeds & Whole Spices', 'measure': '1 tbsp'},
        {'name': 'Cooking Oil / Ghee', 'measure': '3 tbsp'},
      ],
    );

    // =========================================================================
    // 2. KARAHI & HANDI SPECIALS (Dishes 11 - 25)
    // =========================================================================
    addRecipe(
      id: 'pak_111',
      name: 'Peshawari Mutton Karahi',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=800&auto=format&fit=crop',
      tags: 'Karahi,Mutton,Shinwari,Peshawar',
      difficulty: 'Medium',
      prepTime: '40',
      rating: '4.9',
      reviews: '1620',
      steps: [
        'Heat oil in an iron wok (karahi); fry mutton with salt until seared.',
        'Add ginger paste and 1 cup water, cover and cook until meat is tender.',
        'Add halved tomatoes on top, cover for 5 mins, and peel off skins.',
        'Fry on high flame with crushed black pepper, cumin, and sliced green chillies.',
        'Garnish with julienned ginger and serve sizzling with Roghani Naan.'
      ],
      ingredients: [
        {'name': 'Mutton Cuts', 'measure': '1 kg'},
        {'name': 'Fresh Tomatoes', 'measure': '5 ripe'},
        {'name': 'Black Pepper Crushed', 'measure': '1.5 tsp'},
        {'name': 'Julienned Ginger', 'measure': '3 tbsp'},
        {'name': 'Green Chillies', 'measure': '6 slit'},
      ],
    );

    addRecipe(
      id: 'pak_112',
      name: 'Shinwari Chicken Karahi',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=800&auto=format&fit=crop',
      tags: 'Shinwari,Karahi,Chicken,Khyber,Simple',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.9',
      reviews: '1280',
      steps: [
        'Fry chicken in generous hot oil with salt until light golden.',
        'Add whole tomatoes, cover wok until tomato skins loosen and remove skins.',
        'Bhunai (stir-fry) vigorously on high heat with slit green chillies and fresh ginger.',
        'Season only with black pepper and salt to preserve the authentic Shinwari flavor.',
        'Serve bubbling hot.'
      ],
      ingredients: [
        {'name': 'Chicken Bone-in', 'measure': '1 kg'},
        {'name': 'Tomatoes', 'measure': '6 medium'},
        {'name': 'Green Chillies & Ginger', 'measure': 'Generous amount'},
        {'name': 'Black Pepper & Salt', 'measure': 'To taste'},
      ],
    );

    addRecipe(
      id: 'pak_113',
      name: 'Lahori Chicken Handi',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?q=80&w=800&auto=format&fit=crop',
      tags: 'Handi,Creamy,Boneless,Lahore,Makhni',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.8',
      reviews: '950',
      steps: [
        'Sauté boneless chicken cubes in butter and oil with ginger-garlic paste.',
        'Add tomato purée, red chilli, turmeric, and cumin; cook until oil separates.',
        'Lower flame and stir in whisked yogurt and almond paste.',
        'Fold in fresh dairy cream and crushed dried fenugreek (kasuri methi).',
        'Simmer for 3 minutes and serve directly in the clay handi.'
      ],
      ingredients: [
        {'name': 'Boneless Chicken Cubes', 'measure': '700g'},
        {'name': 'Fresh Cream', 'measure': '1/2 cup'},
        {'name': 'Yogurt Whisked', 'measure': '1/2 cup'},
        {'name': 'Tomato Purée', 'measure': '1 cup'},
        {'name': 'Kasuri Methi', 'measure': '1 tbsp'},
        {'name': 'Butter', 'measure': '3 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_114',
      name: 'White Chicken Karahi',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?q=80&w=800&auto=format&fit=crop',
      tags: 'WhiteKarahi,Creamy,Mild,Karachi,Chicken',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.8',
      reviews: '830',
      steps: [
        'Sauté chicken with ginger-garlic paste and white pepper in oil.',
        'Whisk yogurt with crushed cumin, coriander powder, and green chilli paste; add to chicken.',
        'Cook on medium flame until chicken is cooked and sauce thickens.',
        'Stir in fresh cream, butter, and black pepper.',
        'Garnish with ginger slivers and chopped coriander.'
      ],
      ingredients: [
        {'name': 'Chicken Pieces', 'measure': '800g'},
        {'name': 'Thick Yogurt', 'measure': '1 cup'},
        {'name': 'Fresh Heavy Cream', 'measure': '1/2 cup'},
        {'name': 'White Pepper Powder', 'measure': '1.5 tsp'},
        {'name': 'Green Chilli Paste', 'measure': '1 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_115',
      name: 'Balochi Tikka Karahi',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=800&auto=format&fit=crop',
      tags: 'Balochi,Tikka,Karahi,Crispy,Spicy',
      difficulty: 'Medium',
      prepTime: '30',
      rating: '4.9',
      reviews: '1050',
      steps: [
        'Deep fry chicken pieces with whole green chillies and garlic pods until crispy golden.',
        'Drain excess oil leaving 2 tbsp in the pan.',
        'Toss crispy fried chicken with roasted Balochi spice mix (crushed coriander, cumin, red chilli flakes, chaat masala, black salt).',
        'Squeeze fresh lemon juice generously and toss on high heat for 1 minute.',
        'Serve with hot tandoori naan and mint chutney.'
      ],
      ingredients: [
        {'name': 'Chicken Cut in Small Pieces', 'measure': '1 kg'},
        {'name': 'Garlic Pods (whole unpeeled)', 'measure': '12 pods'},
        {'name': 'Green Chillies (whole)', 'measure': '10 pieces'},
        {'name': 'Balochi Spice Mix', 'measure': '3 tbsp'},
        {'name': 'Fresh Lemon Juice', 'measure': '4 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_116',
      name: 'Mutton White Karahi',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?q=80&w=800&auto=format&fit=crop',
      tags: 'Mutton,WhiteKarahi,Royal,Creamy',
      difficulty: 'Hard',
      prepTime: '45',
      rating: '4.9',
      reviews: '740',
      steps: [
        'Boil mutton with ginger, garlic, and salt until succulent and tender.',
        'Transfer mutton into hot ghee in a karahi and sauté with crushed white pepper.',
        'Add thick whisked yogurt, green chilli paste, and roasted cumin powder.',
        'Simmer until rich white gravy forms, then fold in fresh cream and butter.',
        'Garnish with cilantro and ginger juliennes.'
      ],
      ingredients: [
        {'name': 'Mutton with Bone', 'measure': '1 kg'},
        {'name': 'Yogurt', 'measure': '1.5 cups'},
        {'name': 'Cream & Butter', 'measure': '1/2 cup each'},
        {'name': 'White Pepper & Cumin', 'measure': '1 tbsp each'},
      ],
    );

    addRecipe(
      id: 'pak_117',
      name: 'Charsi Chicken Karahi',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=800&auto=format&fit=crop',
      tags: 'Charsi,Karahi,NamakMandi,Peshawar',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.8',
      reviews: '1190',
      steps: [
        'Fry chicken in high heat oil with salt for 7 minutes.',
        'Drain half the oil, add halved ripe tomatoes, cover and simmer until soft.',
        'Remove skins and mash tomatoes into gravy while stir-frying vigorously.',
        'Add freshly crushed coarse black pepper and green chillies.',
        'Serve right off the flame.'
      ],
      ingredients: [
        {'name': 'Fresh Chicken', 'measure': '1 kg'},
        {'name': 'Red Ripe Tomatoes', 'measure': '6'},
        {'name': 'Coarse Black Pepper', 'measure': '1.5 tbsp'},
        {'name': 'Green Chillies', 'measure': '8'},
      ],
    );

    addRecipe(
      id: 'pak_118',
      name: 'Paneer Reshmi Handi',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?q=80&w=800&auto=format&fit=crop',
      tags: 'Paneer,Handi,Vegetarian,Creamy,Desi',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.7',
      reviews: '560',
      steps: [
        'Lightly pan fry paneer cubes in butter until edges turn golden.',
        'Make smooth sauce with blended onions, cashew paste, tomatoes, and ginger-garlic.',
        'Simmer sauce until fragrant and oil glazes the sides.',
        'Gently fold in paneer cubes, fresh cream, and crushed kasuri methi.',
        'Serve steaming hot with tandoori roti.'
      ],
      ingredients: [
        {'name': 'Fresh Paneer Cubes', 'measure': '400g'},
        {'name': 'Cashew Nut Paste', 'measure': '3 tbsp'},
        {'name': 'Fresh Cream', 'measure': '1/2 cup'},
        {'name': 'Tomato Purée', 'measure': '1 cup'},
        {'name': 'Kasuri Methi & Butter', 'measure': '1 tbsp each'},
      ],
    );

    // =========================================================================
    // 3. CURRIES, QORMA, NIHARI & TRADITIONAL STEWS (Dishes 19 - 40)
    // =========================================================================
    addRecipe(
      id: 'pak_119',
      name: 'Authentic Lahori Beef Nihari',
      category: 'Beef',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Nihari,Beef,Stew,Lahore,Spicy',
      difficulty: 'Hard',
      prepTime: '60',
      rating: '5.0',
      reviews: '2400',
      steps: [
        'Fry beef shank (bong) and bone marrow in ghee with ginger-garlic paste.',
        'Add authentic Nihari spice blend and sauté until fragrant.',
        'Pour 6 cups water, cover tight, and slow simmer for 3 hours until meat melts.',
        'Whisk roasted wheat flour in water and slowly pour in to thicken into velvety stew.',
        'Garnish with ginger slivers, green chillies, lemon wedges, and coriander.'
      ],
      ingredients: [
        {'name': 'Beef Shank / Bong Meat', 'measure': '1 kg'},
        {'name': 'Nalli (Bone Marrow)', 'measure': '500g'},
        {'name': 'Roasted Wheat Flour', 'measure': '4 tbsp'},
        {'name': 'Nihari Masala Spice Mix', 'measure': '3 tbsp'},
        {'name': 'Ginger, Lemon, Chillies', 'measure': 'For Garnish'},
      ],
    );

    addRecipe(
      id: 'pak_120',
      name: 'Shahi Chicken Qorma',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?q=80&w=800&auto=format&fit=crop',
      tags: 'Korma,Qorma,Chicken,Mughlai,Festive',
      difficulty: 'Medium',
      prepTime: '35',
      rating: '4.9',
      reviews: '1100',
      steps: [
        'Fry sliced onions in ghee until golden brown; crush finely by hand.',
        'In the fragrant ghee, crack cardamom and cloves, then add chicken and ginger-garlic.',
        'Stir in whisked yogurt mixed with coriander, chilli, and cumin powder.',
        'Cook until chicken is tender, then mix in crushed fried onions and mace-nutmeg powder.',
        'Add 2 drops of kewra essence and simmer until thick danedaar gravy forms.'
      ],
      ingredients: [
        {'name': 'Chicken Pieces', 'measure': '800g'},
        {'name': 'Crispy Fried Onions', 'measure': '1.5 cups'},
        {'name': 'Yogurt Whisked', 'measure': '1.5 cups'},
        {'name': 'Desi Ghee', 'measure': '1/2 cup'},
        {'name': 'Kewra & Nutmeg-Mace', 'measure': 'A pinch'},
      ],
    );

    addRecipe(
      id: 'pak_121',
      name: 'Shahi Beef Haleem',
      category: 'Beef',
      image: 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?q=80&w=800&auto=format&fit=crop',
      tags: 'Haleem,Beef,Lentils,Wheat,SlowCook',
      difficulty: 'Hard',
      prepTime: '60',
      rating: '5.0',
      reviews: '2100',
      steps: [
        'Boil soaked wheat, barley, and 4 mixed lentils with turmeric until fully tender; blend smooth.',
        'In separate pot, cook beef with onions, spices, and ginger-garlic until meat shreds apart.',
        'Combine shredded beef with the blended lentils-wheat mixture.',
        'Mash continuously on low heat with wooden pestle (ghota) until silky stringy texture (resha) develops.',
        'Pour hot ghee onion tarka over top and garnish with mint, ginger, and chaat masala.'
      ],
      ingredients: [
        {'name': 'Beef Chuck Meat', 'measure': '1 kg'},
        {'name': 'Cracked Wheat & Barley', 'measure': '1.5 cups'},
        {'name': 'Mixed Lentils', 'measure': '1 cup'},
        {'name': 'Haleem Masala', 'measure': '3 tbsp'},
        {'name': 'Desi Ghee Tarka', 'measure': '1 cup'},
      ],
    );

    addRecipe(
      id: 'pak_122',
      name: 'Chinioti Mutton Kunna',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Kunna,Mutton,Chiniot,ClayPot,Punjab',
      difficulty: 'Hard',
      prepTime: '55',
      rating: '4.9',
      reviews: '640',
      steps: [
        'In a clay pot (kunna), heat desi ghee and fry mutton shanks with garlic paste.',
        'Add red chilli, cumin, black pepper, and whole garam masala.',
        'Add 4 cups water, seal lid with dough, and slow cook on low heat for 2.5 hours.',
        'Dissolve flour in water and stir in to give smooth body to the broth.',
        'Simmer for 10 minutes and serve piping hot with Roghani Naan.'
      ],
      ingredients: [
        {'name': 'Mutton Shanks', 'measure': '1 kg'},
        {'name': 'Clay Pot (Kunna)', 'measure': '1'},
        {'name': 'Desi Ghee', 'measure': '1/2 cup'},
        {'name': 'Wheat Flour', 'measure': '3 tbsp'},
        {'name': 'Kashmiri Chilli & Cumin', 'measure': '1 tbsp each'},
      ],
    );

    addRecipe(
      id: 'pak_123',
      name: 'Traditional Aloo Gosht Shorba',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=800&auto=format&fit=crop',
      tags: 'AlooGosht,Shorba,HomeStyle,ComfortFood',
      difficulty: 'Medium',
      prepTime: '40',
      rating: '4.9',
      reviews: '1380',
      steps: [
        'Brown onions in oil, add mutton and ginger-garlic; sauté until sealed.',
        'Add tomato purée, turmeric, chilli, coriander, and yogurt; cook until oil separates.',
        'Add halved potatoes and 3 cups warm water.',
        'Cover and cook until mutton and potatoes are fork-tender and aromatic broth forms.',
        'Garnish with whole green chillies, fresh coriander, and garam masala.'
      ],
      ingredients: [
        {'name': 'Mutton Cuts', 'measure': '750g'},
        {'name': 'Potatoes (peeled & halved)', 'measure': '4 medium'},
        {'name': 'Onions & Tomatoes', 'measure': '2 each'},
        {'name': 'Yogurt', 'measure': '1/2 cup'},
        {'name': 'Fresh Coriander', 'measure': '1/2 cup'},
      ],
    );

    addRecipe(
      id: 'pak_124',
      name: 'Lahori Murgh Cholay',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'MurghCholay,Lahore,Breakfast,Chicken,Chana',
      difficulty: 'Medium',
      prepTime: '35',
      rating: '4.8',
      reviews: '990',
      steps: [
        'Boil chickpeas with black tea bag for rich golden hue.',
        'In another pot, cook chicken with onions, yogurt, and aromatic spices until tender.',
        'Add half of boiled chickpeas and mash the remaining half to create thick Lahori gravy.',
        'Combine chicken and chickpea gravy, simmer for 10 minutes on low heat.',
        'Finish with black pepper tarka and serve with hot kulchas.'
      ],
      ingredients: [
        {'name': 'Chicken Bone-in', 'measure': '700g'},
        {'name': 'Boiled Chickpeas', 'measure': '2 cups'},
        {'name': 'Yogurt & Onions', 'measure': '1/2 cup each'},
        {'name': 'Black Pepper & Garam Masala', 'measure': '1 tbsp each'},
      ],
    );

    addRecipe(
      id: 'pak_125',
      name: 'Lahori Mutton Paye',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Paye,Mutton,Lahore,Breakfast,Winter',
      difficulty: 'Hard',
      prepTime: '60',
      rating: '4.9',
      reviews: '1240',
      steps: [
        'Clean and roast trotters (paye) over flame to remove fine hair.',
        'Sauté onions, ginger, garlic, and ground spices in ghee.',
        'Add trotters and brown well, then add 8 cups water.',
        'Slow cook overnight or for 4 hours until gelatinous and tender.',
        'Serve with fresh lemon, ginger slices, and tandoori naan.'
      ],
      ingredients: [
        {'name': 'Mutton Trotters (Paye)', 'measure': '6 pieces'},
        {'name': 'Onions & Ginger-Garlic', 'measure': 'Generous amount'},
        {'name': 'Paye Masala Blend', 'measure': '3 tbsp'},
        {'name': 'Desi Ghee', 'measure': '1/2 cup'},
      ],
    );

    addRecipe(
      id: 'pak_126',
      name: 'Shahi Kofta Curry',
      category: 'Beef',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Kofta,Meatballs,Mughlai,Curry,Beef',
      difficulty: 'Medium',
      prepTime: '40',
      rating: '4.8',
      reviews: '760',
      steps: [
        'Mince beef with roasted gram flour (besan), poppy seeds, and fried onions; shape into round meatballs (koftas).',
        'Prepare rich onion-yogurt gravy in a wide pot.',
        'Gently place raw meatballs into the simmering gravy without stirring with spoon (swirl pot by handles).',
        'Cook covered for 20 minutes until meatballs are firm and juicy.',
        'Garnish with boiled eggs and fresh coriander.'
      ],
      ingredients: [
        {'name': 'Finely Minced Beef', 'measure': '750g'},
        {'name': 'Roasted Besan & Poppy Seeds', 'measure': '2 tbsp each'},
        {'name': 'Yogurt & Fried Onions', 'measure': '1 cup each'},
        {'name': 'Boiled Eggs for Garnish', 'measure': '3'},
      ],
    );

    addRecipe(
      id: 'pak_127',
      name: 'Chicken Jalfrezi',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?q=80&w=800&auto=format&fit=crop',
      tags: 'Jalfrezi,Chicken,Capsicum,StirFry,Desi',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.7',
      reviews: '810',
      steps: [
        'Stir fry boneless chicken strips with garlic until lightly browned.',
        'Add diced bell peppers (capsicum), onions, and tomato chunks.',
        'Toss with tomato ketchup, chilli garlic sauce, soy sauce, and black pepper.',
        'Scramble an egg and fold into the stir-fry.',
        'Serve hot with steamed basmati rice or egg fried rice.'
      ],
      ingredients: [
        {'name': 'Boneless Chicken Strips', 'measure': '600g'},
        {'name': 'Capsicum & Onions Cubed', 'measure': '1 cup each'},
        {'name': 'Tomato Ketchup & Chilli Sauce', 'measure': '3 tbsp each'},
        {'name': 'Egg Scrambled', 'measure': '1'},
      ],
    );

    addRecipe(
      id: 'pak_128',
      name: 'Palak Gosht (Mutton with Spinach)',
      category: 'Lamb',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'PalakGosht,Mutton,Spinach,Green,Desi',
      difficulty: 'Medium',
      prepTime: '40',
      rating: '4.9',
      reviews: '920',
      steps: [
        'Blanch fresh spinach leaves and blend into a coarse purée.',
        'Cook tender mutton with onions, tomatoes, and whole spices.',
        'Add spinach purée, green chillies, and butter into the mutton masala.',
        'Bhunai on medium heat until ghee glistens on the surface.',
        'Serve with warm tandoori roti.'
      ],
      ingredients: [
        {'name': 'Mutton with Bone', 'measure': '800g'},
        {'name': 'Fresh Spinach Leaves', 'measure': '1 kg'},
        {'name': 'Butter & Ghee', 'measure': '4 tbsp'},
        {'name': 'Green Chillies & Ginger', 'measure': 'Finely sliced'},
      ],
    );

    // =========================================================================
    // 4. BARBECUE, KEBABS & TIKKAS (Dishes 29 - 48)
    // =========================================================================
    addRecipe(
      id: 'pak_129',
      name: 'Peshawari Chapli Kabab',
      category: 'Beef',
      image: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=800&auto=format&fit=crop',
      tags: 'Chapli,Kabab,Peshawar,Beef,Crispy',
      difficulty: 'Medium',
      prepTime: '25',
      rating: '5.0',
      reviews: '1980',
      steps: [
        'Knead beef mince with coarse coriander, pomegranate seeds (anardana), chilli flakes, and onions.',
        'Add makki atta (cornmeal) and a beaten egg to bind well.',
        'Shape into large flat patties and place a thin tomato slice in the middle.',
        'Shallow fry on a flat tawa in ghee until edges are crispy and golden.',
        'Serve with naan, raita, and sliced onions.'
      ],
      ingredients: [
        {'name': 'Beef Mince with Fat', 'measure': '800g'},
        {'name': 'Crushed Anardana', 'measure': '2 tbsp'},
        {'name': 'Coarse Coriander Seeds', 'measure': '2 tbsp'},
        {'name': 'Makki Atta', 'measure': '3 tbsp'},
        {'name': 'Tomatoes & Green Chillies', 'measure': '2 each'},
      ],
    );

    addRecipe(
      id: 'pak_130',
      name: 'Chicken Seekh Kabab',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=800&auto=format&fit=crop',
      tags: 'Seekh,Kabab,BBQ,Grilled,Chicken',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.8',
      reviews: '1150',
      steps: [
        'Mince chicken with squeezed onions, mint, green chillies, and roasted besan.',
        'Infuse with charcoal smoke for 3 minutes for authentic barbecue aroma.',
        'Shape onto metal skewers with wet hands.',
        'Grill over hot charcoal or pan fry, basting with butter.',
        'Serve with mint chutney and fresh onion rings.'
      ],
      ingredients: [
        {'name': 'Chicken Mince', 'measure': '700g'},
        {'name': 'Roasted Besan', 'measure': '2 tbsp'},
        {'name': 'Onions & Mint', 'measure': '1/2 cup each'},
        {'name': 'Butter for Basting', 'measure': '3 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_131',
      name: 'Beef Bihari Kabab',
      category: 'Beef',
      image: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=800&auto=format&fit=crop',
      tags: 'Bihari,Kabab,Beef,Tender,Smoky',
      difficulty: 'Medium',
      prepTime: '30',
      rating: '4.9',
      reviews: '890',
      steps: [
        'Cut beef into thin strips (pasanday); marinate with raw papaya, yogurt, and mustard oil for 4 hours.',
        'Add roasted gram flour, fried onion paste, and crushed spices.',
        'Thread onto skewers in a continuous ribbon weave.',
        'Barbecue on charcoal grill until smoky, charred, and melt-in-mouth tender.',
        'Serve with paratha and imli (tamarind) chutney.'
      ],
      ingredients: [
        {'name': 'Thin Beef Pasanday Strips', 'measure': '800g'},
        {'name': 'Raw Papaya Paste', 'measure': '2 tbsp'},
        {'name': 'Mustard Oil & Yogurt', 'measure': '3 tbsp + 1/2 cup'},
        {'name': 'Bihari Kabab Masala', 'measure': '2.5 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_132',
      name: 'Chicken Malai Boti',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=800&auto=format&fit=crop',
      tags: 'MalaiBoti,Creamy,BBQ,Mild,Juicy',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.9',
      reviews: '1430',
      steps: [
        'Marinate boneless chicken cubes with cream, thick yogurt, cheese, white pepper, and green chilli paste for 2 hours.',
        'Skewer the chicken pieces.',
        'Grill over medium charcoal or bake in 200°C oven for 15 minutes.',
        'Brush with melted butter and lemon juice.',
        'Serve juicy and hot with garlic naan.'
      ],
      ingredients: [
        {'name': 'Boneless Chicken Breast Cubes', 'measure': '750g'},
        {'name': 'Fresh Cream & Cream Cheese', 'measure': '1/2 cup + 2 tbsp'},
        {'name': 'Greek Yogurt', 'measure': '1/2 cup'},
        {'name': 'White Pepper & Cardamom Powder', 'measure': '1 tsp each'},
      ],
    );

    addRecipe(
      id: 'pak_133',
      name: 'Tandoori Chicken Chargha (Lahori)',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=800&auto=format&fit=crop',
      tags: 'Chargha,Lahore,WholeChicken,Crispy,Fried',
      difficulty: 'Hard',
      prepTime: '45',
      rating: '4.9',
      reviews: '970',
      steps: [
        'Make deep incisions on a whole skinned chicken.',
        'Marinate with yogurt, lemon juice, ginger-garlic, and Chargha spice blend for 4 hours.',
        'Steam the whole chicken for 20 minutes until almost cooked.',
        'Deep fry in hot oil for 6 minutes until skin is crispy and dark golden.',
        'Dust with chaat masala and serve with french fries and salad.'
      ],
      ingredients: [
        {'name': 'Whole Chicken Skinned', 'measure': '1.2 kg'},
        {'name': 'Lahori Chargha Masala', 'measure': '3 tbsp'},
        {'name': 'Lemon Juice & Yogurt', 'measure': '1/4 cup each'},
        {'name': 'Oil for Deep Frying', 'measure': '3 cups'},
      ],
    );

    addRecipe(
      id: 'pak_134',
      name: 'Balochi Chicken Sajji',
      category: 'Chicken',
      image: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=800&auto=format&fit=crop',
      tags: 'Sajji,Balochistan,Quetta,Rice,Roast',
      difficulty: 'Hard',
      prepTime: '55',
      rating: '5.0',
      reviews: '1150',
      steps: [
        'Marinate whole chicken with salt, carom seeds (ajwain), and vinegar/lemon for 2 hours.',
        'Slow roast around burning logs or in oven for 45 minutes until skin is crackling crisp.',
        'Sprinkle special Sajji masala (dried pomegranate, black salt, chaat masala).',
        'Stuff with aromatic spiced boiled rice and serve with kaak roti.'
      ],
      ingredients: [
        {'name': 'Whole Chicken with Skin', 'measure': '1.3 kg'},
        {'name': 'Ajwain & Black Salt', 'measure': '1 tbsp each'},
        {'name': 'Lemon Juice', 'measure': '4 tbsp'},
        {'name': 'Spiced Basmati Rice', 'measure': '2 cups cooked'},
      ],
    );

    addRecipe(
      id: 'pak_135',
      name: 'Lahori Fried Fish (Bashir Style)',
      category: 'Seafood',
      image: 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?q=80&w=800&auto=format&fit=crop',
      tags: 'Fish,LahoriFish,Crispy,Besan,Winter',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.8',
      reviews: '920',
      steps: [
        'Marinate fish fillets (Rahoo/Surmai) with carom seeds (ajwain), garlic water, turmeric, and lemon for 30 minutes.',
        'Dip in spiced gram flour (besan) batter.',
        'Deep fry in mustard oil on medium heat until light golden; remove and rest for 3 minutes.',
        'Flash fry a second time in hot oil for 1 minute for ultimate crunch.',
        'Sprinkle with chaat masala and serve with radish salad and plum chutney.'
      ],
      ingredients: [
        {'name': 'Fish Fillets (Rahoo/Surmai)', 'measure': '800g'},
        {'name': 'Gram Flour (Besan)', 'measure': '1 cup'},
        {'name': 'Ajwain (Carom Seeds)', 'measure': '1 tbsp'},
        {'name': 'Mustard Oil for Frying', 'measure': '2 cups'},
      ],
    );

    addRecipe(
      id: 'pak_136',
      name: 'Traditional Shami Kabab (Beef)',
      category: 'Beef',
      image: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?q=80&w=800&auto=format&fit=crop',
      tags: 'ShamiKabab,Beef,ChanaDaal,Snack,TeaTime',
      difficulty: 'Medium',
      prepTime: '35',
      rating: '4.9',
      reviews: '1720',
      steps: [
        'Boil beef pieces with chana daal, whole red chillies, ginger-garlic, and whole garam masala until liquid evaporates.',
        'Grind the mixture finely on sil batta or food processor.',
        'Mix with chopped onions, green chillies, mint, coriander, and an egg.',
        'Shape into round flat kababs.',
        'Dip in beaten egg and shallow fry in ghee until golden brown on both sides.'
      ],
      ingredients: [
        {'name': 'Beef Boneless Cuts', 'measure': '600g'},
        {'name': 'Chana Daal (Split Chickpeas)', 'measure': '1 cup'},
        {'name': 'Whole Button Red Chillies', 'measure': '8'},
        {'name': 'Fresh Mint & Green Chillies', 'measure': '1/2 cup'},
        {'name': 'Eggs for Dipping', 'measure': '2'},
      ],
    );

    // =========================================================================
    // 5. VEGETARIAN & DAAL DISHES (Dishes 49 - 68)
    // =========================================================================
    addRecipe(
      id: 'pak_137',
      name: 'Dhaba Style Daal Tadka',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Daal,Tadka,Vegetarian,Healthy,Dhaba',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.8',
      reviews: '890',
      steps: [
        'Boil Chana and Moong daal with turmeric, salt, and ginger until creamy.',
        'In a frying pan, heat desi ghee and fry sliced garlic until golden.',
        'Add cumin seeds, whole red button chillies, and Kashmiri red chilli powder.',
        'Pour sizzling hot tarka directly over the boiling daal.',
        'Garnish with coriander and lemon juice; serve with zeera rice.'
      ],
      ingredients: [
        {'name': 'Chana & Moong Daal', 'measure': '1 cup each'},
        {'name': 'Desi Ghee', 'measure': '4 tbsp'},
        {'name': 'Garlic Cloves Sliced', 'measure': '6'},
        {'name': 'Cumin Seeds & Button Chillies', 'measure': '1 tsp + 5 chillies'},
      ],
    );

    addRecipe(
      id: 'pak_138',
      name: 'Daal Makhni Shahi',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'DaalMakhni,BlackLentil,Butter,Creamy,Rich',
      difficulty: 'Medium',
      prepTime: '45',
      rating: '4.9',
      reviews: '1020',
      steps: [
        'Slow cook black urad lentils and kidney beans (rajma) overnight.',
        'Simmer with fresh tomato purée, ginger paste, and Kashmiri red chilli powder for 40 minutes.',
        'Add generous amount of fresh butter and dairy cream.',
        'Mash against pot sides for signature creamy texture.',
        'Finish with crushed kasuri methi.'
      ],
      ingredients: [
        {'name': 'Whole Black Urad Lentils', 'measure': '1.5 cups'},
        {'name': 'Kidney Beans (Rajma)', 'measure': '1/2 cup'},
        {'name': 'Butter & Fresh Cream', 'measure': '1/2 cup each'},
        {'name': 'Tomato Purée', 'measure': '1 cup'},
      ],
    );

    addRecipe(
      id: 'pak_139',
      name: 'Sarson Ka Saag',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Saag,Punjab,MustardGreens,Winter,Makhan',
      difficulty: 'Medium',
      prepTime: '40',
      rating: '5.0',
      reviews: '1280',
      steps: [
        'Boil fresh mustard leaves (sarson), spinach, and bathua with green chillies and garlic.',
        'Mash coarsely with a wooden whisk (madhani).',
        'Stir in makki atta (cornmeal) to thicken.',
        'Prepare white butter and garlic tarka and pour on top.',
        'Serve with hot Makki ki Roti and jaggery (gur).'
      ],
      ingredients: [
        {'name': 'Mustard Greens (Sarson)', 'measure': '1 kg'},
        {'name': 'Spinach (Palak)', 'measure': '500g'},
        {'name': 'Makki Atta', 'measure': '3 tbsp'},
        {'name': 'White Desi Butter (Makhan)', 'measure': '4 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_140',
      name: 'Punjabi Kadi Pakora',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Kadi,Pakora,Yogurt,Punjab,Desi',
      difficulty: 'Medium',
      prepTime: '35',
      rating: '4.8',
      reviews: '810',
      steps: [
        'Whisk sour yogurt with gram flour (besan), water, turmeric, and red chilli; simmer for 40 minutes on low heat.',
        'Make crispy onion-potato pakoras and drain on paper towel.',
        'Drop hot pakoras into the thick simmering yellow kadi.',
        'Prepare tarka of cumin, mustard seeds, curry leaves, and dry red chillies in hot oil.',
        'Pour tarka over kadi and serve with boiled rice.'
      ],
      ingredients: [
        {'name': 'Sour Yogurt', 'measure': '2 cups'},
        {'name': 'Gram Flour (Besan)', 'measure': '1.5 cups'},
        {'name': 'Onions & Potatoes for Pakoras', 'measure': '2 each'},
        {'name': 'Curry Leaves & Mustard Seeds', 'measure': '1 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_141',
      name: 'Daal Mash Fry (Dhaba Style)',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'DaalMash,WhiteLentil,Dhaba,Fry',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.8',
      reviews: '690',
      steps: [
        'Boil washed white urad daal (mash) until grains are tender but separate (al dente).',
        'In a pan, fry onions, tomatoes, and ginger-garlic paste in butter/oil.',
        'Add cumin, chilli flakes, and black pepper.',
        'Toss boiled daal in the masala on high flame.',
        'Garnish with green chillies and ginger slivers.'
      ],
      ingredients: [
        {'name': 'White Urad Daal (Daal Mash)', 'measure': '1.5 cups'},
        {'name': 'Tomatoes & Onions', 'measure': '1 cup chopped'},
        {'name': 'Butter & Ghee', 'measure': '3 tbsp'},
        {'name': 'Ginger Juliennes', 'measure': '2 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_142',
      name: 'Bhindi Masala Fry',
      category: 'Vegetarian',
      image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop',
      tags: 'Bhindi,Okra,Vegetarian,Crispy,HomeStyle',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.7',
      reviews: '620',
      steps: [
        'Wash, dry completely, and chop okra (bhindi) into 1-inch rounds.',
        'Flash fry okra in hot oil until non-slimy; remove.',
        'Sauté sliced onions and tomatoes with cumin, turmeric, and amchur (dry mango) powder.',
        'Add fried bhindi and toss on low dum for 5 minutes.',
        'Serve with chapati.'
      ],
      ingredients: [
        {'name': 'Fresh Okra (Bhindi)', 'measure': '500g'},
        {'name': 'Onions Sliced', 'measure': '3 medium'},
        {'name': 'Tomatoes Chopped', 'measure': '2 medium'},
        {'name': 'Amchur Powder & Cumin', 'measure': '1 tsp each'},
      ],
    );

    // =========================================================================
    // 6. STREET FOOD, BREAKFAST & SNACKS (Dishes 43 - 56)
    // =========================================================================
    addRecipe(
      id: 'pak_143',
      name: 'Halwa Puri & Chana Tarkari',
      category: 'Breakfast',
      image: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?q=80&w=800&auto=format&fit=crop',
      tags: 'Halwa,Puri,Chana,Breakfast,SundaySpecial',
      difficulty: 'Medium',
      prepTime: '30',
      rating: '5.0',
      reviews: '2300',
      steps: [
        'Simmer boiled chickpeas with nigella seeds (kalonji), pickle spice (achari masala), and potato mash.',
        'Roast semolina (sooji) in desi ghee with saffron sugar syrup to make aromatic halwa.',
        'Knead fine flour dough into thin discs and deep fry puris in piping hot oil for 10 seconds until puffed.',
        'Serve hot puris with spicy chana and sweet halwa.'
      ],
      ingredients: [
        {'name': 'All-Purpose Flour (Maida)', 'measure': '2 cups'},
        {'name': 'Semolina (Sooji)', 'measure': '1 cup'},
        {'name': 'Chickpeas Boiled', 'measure': '2 cups'},
        {'name': 'Desi Ghee & Sugar', 'measure': '1/2 cup + 1 cup'},
      ],
    );

    addRecipe(
      id: 'pak_144',
      name: 'Karachi Bun Kabab (Street Style)',
      category: 'Breakfast',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800&auto=format&fit=crop',
      tags: 'BunKabab,Karachi,StreetFood,Burger,Snack',
      difficulty: 'Easy',
      prepTime: '15',
      rating: '4.9',
      reviews: '1410',
      steps: [
        'Make patties from boiled chana daal and beef/potato mash with chaat masala.',
        'Dip patty in whipped fluffy egg whites and fry on flat tawa.',
        'Toast soft burger buns in butter.',
        'Layer with spicy green chutney, egg-coated patty, sliced onions, tomatoes, and sweet tamarind sauce.',
        'Serve hot with salted fries.'
      ],
      ingredients: [
        {'name': 'Burger Buns', 'measure': '4'},
        {'name': 'Daal Shami Patties', 'measure': '4'},
        {'name': 'Whipped Egg Whites', 'measure': '2 eggs'},
        {'name': 'Green Mint Chutney & Tamarind Chutney', 'measure': '1/4 cup each'},
        {'name': 'Onion Rings', 'measure': '1 cup'},
      ],
    );

    addRecipe(
      id: 'pak_145',
      name: 'Crispy Chicken & Potato Samosa',
      category: 'Breakfast',
      image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop',
      tags: 'Samosa,Crispy,Snack,Ramadan,StreetFood',
      difficulty: 'Medium',
      prepTime: '25',
      rating: '4.9',
      reviews: '1650',
      steps: [
        'Prepare filling of minced chicken or boiled potatoes with cumin, coriander, green chillies, and peas.',
        'Roll crispy pastry dough (patti) into cone shapes and stuff with filling.',
        'Seal edges tightly with flour-water paste.',
        'Deep fry in medium-hot oil until golden brown and super flaky.',
        'Serve with mint yogurt dip.'
      ],
      ingredients: [
        {'name': 'Samosa Patti / Dough', 'measure': '12 sheets'},
        {'name': 'Minced Chicken or Potato Mash', 'measure': '2 cups'},
        {'name': 'Green Peas & Chillies', 'measure': '1/2 cup'},
        {'name': 'Cumin & Chaat Masala', 'measure': '1 tbsp each'},
      ],
    );

    addRecipe(
      id: 'pak_146',
      name: 'Karachi Dahi Baray',
      category: 'Breakfast',
      image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop',
      tags: 'DahiBaray,DahiBhalla,StreetFood,Chaat,Yogurt',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.8',
      reviews: '1190',
      steps: [
        'Deep fry lentil fritters (baray) made from whipped mash/moong daal batter; soak in warm water for 10 mins and gently squeeze.',
        'Arrange soft baray in a dish and pour thick sweetened creamy yogurt over top.',
        'Drizzle with tangy tamarind (imli) chutney and spicy green chutney.',
        'Sprinkle special Karachi dahi bara chaat masala and crispy papri.',
        'Serve chilled.'
      ],
      ingredients: [
        {'name': 'Mash/Moong Daal Fritters', 'measure': '10 pieces'},
        {'name': 'Sweet Creamy Yogurt', 'measure': '3 cups'},
        {'name': 'Imli (Tamarind) Chutney', 'measure': '1/2 cup'},
        {'name': 'Chaat Masala & Papri', 'measure': 'For Garnish'},
      ],
    );

    addRecipe(
      id: 'pak_147',
      name: 'Desi Aloo Paratha with Makhan',
      category: 'Breakfast',
      image: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?q=80&w=800&auto=format&fit=crop',
      tags: 'Paratha,Aloo,Breakfast,Makhan,Desi',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '5.0',
      reviews: '1890',
      steps: [
        'Mash boiled potatoes with chopped green chillies, fresh coriander, chaat masala, and roasted cumin.',
        'Roll two small whole wheat dough pedas and stuff spiced potato filling in between; seal edges.',
        'Roll gently into a flat round paratha.',
        'Cook on hot tawa, basting with desi ghee until both sides are golden crispy.',
        'Top with a dollop of fresh white butter (makhan) and serve with pickle and tea.'
      ],
      ingredients: [
        {'name': 'Whole Wheat Flour Dough', 'measure': '2 cups'},
        {'name': 'Boiled Potatoes Mashed', 'measure': '3 medium'},
        {'name': 'Desi Ghee & Fresh Makhan', 'measure': 'Generous amount'},
        {'name': 'Green Chillies & Coriander', 'measure': 'Finely chopped'},
      ],
    );

    // =========================================================================
    // 7. DESSERTS & SWEETS (Dishes 57 - 65)
    // =========================================================================
    addRecipe(
      id: 'pak_148',
      name: 'Shahi Gulab Jamun',
      category: 'Dessert',
      image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop',
      tags: 'GulabJamun,Mithai,Dessert,Sweet,Royal',
      difficulty: 'Medium',
      prepTime: '30',
      rating: '5.0',
      reviews: '2100',
      steps: [
        'Knead milk powder, flour, semolina, ghee, and milk into smooth soft dough.',
        'Shape into small crack-free balls.',
        'Deep fry on low heat in ghee until deep golden brown.',
        'Immerse in warm rose-cardamom sugar syrup for 30 minutes.',
        'Garnish with pistachios and silver leaf (warq).'
      ],
      ingredients: [
        {'name': 'Milk Powder', 'measure': '1.5 cups'},
        {'name': 'All-Purpose Flour', 'measure': '3 tbsp'},
        {'name': 'Sugar & Water for Syrup', 'measure': '2 cups each'},
        {'name': 'Rose Water & Cardamom', 'measure': '1 tsp each'},
      ],
    );

    addRecipe(
      id: 'pak_149',
      name: 'Zafrani Shahi Kheer',
      category: 'Dessert',
      image: 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?q=80&w=800&auto=format&fit=crop',
      tags: 'Kheer,Dessert,RicePudding,Saffron,Matka',
      difficulty: 'Easy',
      prepTime: '35',
      rating: '4.9',
      reviews: '1350',
      steps: [
        'Soak basmati rice and crush coarsely.',
        'Boil full-fat whole milk in heavy pot; add crushed rice and simmer on low for 25 mins.',
        'Add sugar, cardamom powder, and saffron dissolved in warm milk.',
        'Stir in condensed milk or khoya for royal richness.',
        'Pour into earthen clay bowls and chill before serving.'
      ],
      ingredients: [
        {'name': 'Full Cream Fresh Milk', 'measure': '1.5 Litres'},
        {'name': 'Basmati Rice', 'measure': '1/2 cup'},
        {'name': 'Sugar & Saffron', 'measure': '3/4 cup + 1/2 tsp'},
        {'name': 'Almonds & Pistachios', 'measure': '1/4 cup'},
      ],
    );

    addRecipe(
      id: 'pak_150',
      name: 'Traditional Gajar Ka Halwa',
      category: 'Dessert',
      image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop',
      tags: 'GajarHalwa,CarrotHalwa,Winter,Mithai,DesiGhee',
      difficulty: 'Medium',
      prepTime: '45',
      rating: '5.0',
      reviews: '2200',
      steps: [
        'Grate fresh red winter carrots and cook in milk until milk evaporates completely.',
        'Add pure desi ghee and roast (bhunai) on medium heat until carrots turn shiny and aromatic.',
        'Add sugar and crushed green cardamom pods.',
        'Fold in fresh mawa (khoya) and roasted nuts.',
        'Serve warm topped with extra khoya.'
      ],
      ingredients: [
        {'name': 'Fresh Red Carrots Grated', 'measure': '1.5 kg'},
        {'name': 'Whole Milk', 'measure': '1 Litre'},
        {'name': 'Desi Ghee', 'measure': '1/2 cup'},
        {'name': 'Khoya (Mawa)', 'measure': '1 cup'},
        {'name': 'Sugar & Mixed Nuts', 'measure': '1 cup each'},
      ],
    );

    addRecipe(
      id: 'pak_151',
      name: 'Pistachio Rasmalai',
      category: 'Dessert',
      image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop',
      tags: 'Rasmalai,Milk,Pistachio,Sweet,Royal',
      difficulty: 'Medium',
      prepTime: '30',
      rating: '4.9',
      reviews: '1410',
      steps: [
        'Simmer whole milk with saffron, sugar, and crushed cardamom until reduced to rabri.',
        'Knead milk powder, egg, and baking powder into smooth discs.',
        'Drop dumplings into boiling rabri milk; they will expand and float.',
        'Simmer for 8 minutes, then remove from heat.',
        'Chill thoroughly and garnish with pistachios.'
      ],
      ingredients: [
        {'name': 'Whole Milk', 'measure': '1.5 Litres'},
        {'name': 'Milk Powder', 'measure': '1 cup'},
        {'name': 'Sugar & Saffron', 'measure': '1/2 cup + 1/4 tsp'},
        {'name': 'Sliced Pistachios', 'measure': '3 tbsp'},
      ],
    );

    addRecipe(
      id: 'pak_152',
      name: 'Royal Shahi Tukray',
      category: 'Dessert',
      image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop',
      tags: 'ShahiTukray,BreadPudding,Mughlai,Dessert,Eid',
      difficulty: 'Easy',
      prepTime: '25',
      rating: '4.8',
      reviews: '960',
      steps: [
        'Cut bread slices into triangles and fry in desi ghee until crisp and golden.',
        'Dip fried bread briefly in warm cardamom sugar syrup.',
        'Arrange on serving platter and pour thick creamy saffron rabri over top.',
        'Garnish with almonds, pistachios, and silver warq.'
      ],
      ingredients: [
        {'name': 'White Bread Slices', 'measure': '6 slices'},
        {'name': 'Desi Ghee for Frying', 'measure': '1/2 cup'},
        {'name': 'Thick Saffron Rabri Milk', 'measure': '2 cups'},
        {'name': 'Cardamom Syrup', 'measure': '1 cup'},
      ],
    );

    addRecipe(
      id: 'pak_153',
      name: 'Eid Special Sheer Khurma',
      category: 'Dessert',
      image: 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?q=80&w=800&auto=format&fit=crop',
      tags: 'SheerKhurma,EidSpecial,Dates,Vermicelli,Dessert',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '5.0',
      reviews: '1850',
      steps: [
        'Roast fine vermicelli (seviyan) in desi ghee with sliced dates (choharay) and almonds.',
        'Bring whole milk to a boil and add roasted vermicelli mixture.',
        'Cook on low heat for 10 minutes until milk turns creamy.',
        'Stir in sugar, saffron, and cardamom powder.',
        'Serve warm or chilled on Eid morning.'
      ],
      ingredients: [
        {'name': 'Fine Vermicelli (Seviyan)', 'measure': '1 cup'},
        {'name': 'Whole Milk', 'measure': '1.5 Litres'},
        {'name': 'Dry Dates (Choharay)', 'measure': '6 sliced'},
        {'name': 'Pistachios & Almonds', 'measure': '1/2 cup'},
      ],
    );

    addRecipe(
      id: 'pak_154',
      name: 'Kashmiri Pink Chai (Noon Chai)',
      category: 'Breakfast',
      image: 'https://images.unsplash.com/photo-1546833998-877b37c2e5c6?q=80&w=800&auto=format&fit=crop',
      tags: 'KashmiriChai,PinkTea,Winter,Tea,Nuts',
      difficulty: 'Easy',
      prepTime: '20',
      rating: '4.9',
      reviews: '1780',
      steps: [
        'Brew special green tea leaves with baking soda and cold water, aerating with ladle to extract pink color.',
        'Add whole milk, cardamom, and a pinch of salt/sugar.',
        'Simmer until creamy pastel pink tea forms.',
        'Pour into cups and top with crushed pistachios and almonds.'
      ],
      ingredients: [
        {'name': 'Kashmiri Green Tea Leaves', 'measure': '2 tbsp'},
        {'name': 'Baking Soda', 'measure': '1/4 tsp'},
        {'name': 'Whole Milk', 'measure': '3 cups'},
        {'name': 'Crushed Pistachios & Almonds', 'measure': '1/4 cup'},
      ],
    );

    // =========================================================================
    // 8. ADDITIONAL SIGNATURE PAKISTANI DISHES (Dishes 55 - 90+)
    // =========================================================================
    final additionalDishNames = [
      {'name': 'Koyla Karahi Chicken', 'cat': 'Chicken', 'tags': 'Smoky,Koyla,Karahi,Chicken', 'time': '25', 'diff': 'Easy'},
      {'name': 'Green Masala Chicken Karahi', 'cat': 'Chicken', 'tags': 'Hariyali,Green,Karahi,Chicken', 'time': '25', 'diff': 'Easy'},
      {'name': 'Chicken Achari Handi', 'cat': 'Chicken', 'tags': 'Achari,Pickle,Spicy,Handi', 'time': '30', 'diff': 'Medium'},
      {'name': 'Chicken Ginger Curry', 'cat': 'Chicken', 'tags': 'Ginger,Chicken,Curry,Dhaba', 'time': '25', 'diff': 'Easy'},
      {'name': 'Bhindi Gosht', 'cat': 'Lamb', 'tags': 'Bhindi,Mutton,Desi,HomeStyle', 'time': '40', 'diff': 'Medium'},
      {'name': 'Karela Gosht', 'cat': 'Beef', 'tags': 'Karela,Beef,Bittergourd,Traditional', 'time': '45', 'diff': 'Medium'},
      {'name': 'Dal Gosht (Chana Daal Mutton)', 'cat': 'Lamb', 'tags': 'DalGosht,Mutton,ChanaDaal,Hearty', 'time': '45', 'diff': 'Medium'},
      {'name': 'Bong Paye Lahori', 'cat': 'Beef', 'tags': 'Bong,Paye,Lahore,Breakfast,SlowCook', 'time': '60', 'diff': 'Hard'},
      {'name': 'Brain Masala (Maghaz Fry)', 'cat': 'Beef', 'tags': 'Maghaz,Brain,Fry,Masala,StreetFood', 'time': '20', 'diff': 'Easy'},
      {'name': 'Gurda Kapoora Masala', 'cat': 'Beef', 'tags': 'Gurda,Kapoora,Tawa,Masala,StreetFood', 'time': '20', 'diff': 'Easy'},
      {'name': 'Chicken Reshmi Kabab', 'cat': 'Chicken', 'tags': 'Reshmi,Kabab,BBQ,Juicy,Chicken', 'time': '20', 'diff': 'Easy'},
      {'name': 'Beef Gola Kabab', 'cat': 'Beef', 'tags': 'GolaKabab,Beef,Juicy,BBQ,MeltInMouth', 'time': '25', 'diff': 'Medium'},
      {'name': 'Dhaga Kabab (Burns Road)', 'cat': 'Beef', 'tags': 'DhagaKabab,BurnsRoad,Karachi,StreetFood', 'time': '30', 'diff': 'Medium'},
      {'name': 'Kasturi Boti Kabab', 'cat': 'Chicken', 'tags': 'Kasturi,Boti,BBQ,Spicy,Chicken', 'time': '25', 'diff': 'Easy'},
      {'name': 'Mutton BBQ Chops', 'cat': 'Lamb', 'tags': 'Chops,Mutton,BBQ,Grilled,Juicy', 'time': '35', 'diff': 'Medium'},
      {'name': 'Seekh Kabab Karahi', 'cat': 'Beef', 'tags': 'SeekhKabab,Karahi,Fusion,Curry', 'time': '25', 'diff': 'Easy'},
      {'name': 'Aloo Baingan Masala', 'cat': 'Vegetarian', 'tags': 'AlooBaingan,Eggplant,HomeStyle,Vegetarian', 'time': '25', 'diff': 'Easy'},
      {'name': 'Mix Vegetable Korma', 'cat': 'Vegetarian', 'tags': 'MixVeg,Korma,Vegetarian,Healthy', 'time': '25', 'diff': 'Easy'},
      {'name': 'Lobia Ka Salan (Black Eyed Peas)', 'cat': 'Vegetarian', 'tags': 'Lobia,Curry,Healthy,Vegetarian', 'time': '30', 'diff': 'Easy'},
      {'name': 'Aloo Gobi Fry', 'cat': 'Vegetarian', 'tags': 'AlooGobi,Cauliflower,Vegetarian,Dry', 'time': '20', 'diff': 'Easy'},
      {'name': 'Shahi Paneer Tikka', 'cat': 'Vegetarian', 'tags': 'Paneer,Tikka,BBQ,Vegetarian,Grilled', 'time': '20', 'diff': 'Easy'},
      {'name': 'Crispy Keema Samosa', 'cat': 'Breakfast', 'tags': 'Samosa,Keema,Beef,Crispy,Snack', 'time': '25', 'diff': 'Medium'},
      {'name': 'Keema Kachori & Aloo Tarkari', 'cat': 'Breakfast', 'tags': 'Kachori,Keema,Karachi,Breakfast', 'time': '30', 'diff': 'Medium'},
      {'name': 'Chicken Spring Rolls', 'cat': 'Breakfast', 'tags': 'SpringRoll,Chicken,Snack,Crispy', 'time': '20', 'diff': 'Easy'},
      {'name': 'Lahori Papri Chaat', 'cat': 'Breakfast', 'tags': 'PapriChaat,Chaat,Lahore,StreetFood', 'time': '15', 'diff': 'Easy'},
      {'name': 'Karachi Gol Gappay (Pani Puri)', 'cat': 'Breakfast', 'tags': 'GolGappay,PaniPuri,StreetFood,Spicy', 'time': '15', 'diff': 'Easy'},
      {'name': 'Keema Naan (Tandoori)', 'cat': 'Beef', 'tags': 'KeemaNaan,Tandoor,Bread,Beef,Desi', 'time': '25', 'diff': 'Medium'},
      {'name': 'Anda Shami Burger (Karachi)', 'cat': 'Breakfast', 'tags': 'AndaShami,Burger,Karachi,StreetFood', 'time': '15', 'diff': 'Easy'},
      {'name': 'Crispy Mix Pakora Platter', 'cat': 'Breakfast', 'tags': 'Pakora,Snack,RainyDay,Iftar,Crispy', 'time': '15', 'diff': 'Easy'},
      {'name': 'Lahori Rabri Falooda', 'cat': 'Dessert', 'tags': 'Falooda,Rabri,Lahore,Dessert,IceCream', 'time': '15', 'diff': 'Easy'},
      {'name': 'Crispy Hot Jalebi', 'cat': 'Dessert', 'tags': 'Jalebi,Crispy,Sweet,Mithai,DesiGhee', 'time': '25', 'diff': 'Medium'},
      {'name': 'Besan Ka Ladoo', 'cat': 'Dessert', 'tags': 'BesanLadoo,Mithai,Sweet,DesiGhee', 'time': '25', 'diff': 'Easy'},
      {'name': 'Sooji Ka Desi Halwa', 'cat': 'Dessert', 'tags': 'SoojiHalwa,DesiGhee,Sweet,Breakfast', 'time': '20', 'diff': 'Easy'},
      {'name': 'Fish Biryani (Karachi Coastal)', 'cat': 'Seafood', 'tags': 'FishBiryani,Seafood,Rice,Karachi', 'time': '40', 'diff': 'Medium'},
      {'name': 'Fish Karahi Masaledar', 'cat': 'Seafood', 'tags': 'FishKarahi,Seafood,Curry,Spicy', 'time': '25', 'diff': 'Easy'},
      {'name': 'Prawn Masala (Karachi Style)', 'cat': 'Seafood', 'tags': 'PrawnMasala,Seafood,Curry,Coastal', 'time': '20', 'diff': 'Easy'},
      {'name': 'Hyderabadi Beef Dum Biryani', 'cat': 'Beef', 'tags': 'Biryani,Beef,Dum,Hyderabad,Spicy', 'time': '55', 'diff': 'Hard'},
      {'name': 'Shahjahani Chicken Biryani', 'cat': 'Chicken', 'tags': 'Biryani,Mughlai,Royal,Chicken', 'time': '50', 'diff': 'Medium'},
      {'name': 'Bombay Biryani with Potatoes', 'cat': 'Chicken', 'tags': 'Biryani,Bombay,Spicy,Potatoes', 'time': '45', 'diff': 'Medium'},
      {'name': 'Kachche Gosht Ki Dum Biryani', 'cat': 'Lamb', 'tags': 'Biryani,KachchaGosht,Dum,Mutton', 'time': '60', 'diff': 'Hard'},
      {'name': 'Lahori Tawa Chicken', 'cat': 'Chicken', 'tags': 'TawaChicken,Lahore,Spicy,StreetFood', 'time': '20', 'diff': 'Easy'},
      {'name': 'Murgh Musallam Shahi', 'cat': 'Chicken', 'tags': 'MurghMusallam,Royal,WholeChicken,Feast', 'time': '55', 'diff': 'Hard'},
      {'name': 'Chicken White Handi (Karachi)', 'cat': 'Chicken', 'tags': 'WhiteHandi,Creamy,Boneless,Karachi', 'time': '25', 'diff': 'Easy'},
      {'name': 'Mutton Ribs BBQ (Champay)', 'cat': 'Lamb', 'tags': 'Champay,Ribs,Mutton,BBQ,Juicy', 'time': '40', 'diff': 'Medium'},
      {'name': 'Shahi Matka Kulfi Falooda', 'cat': 'Dessert', 'tags': 'Kulfi,Falooda,Matka,Rabri,Dessert', 'time': '15', 'diff': 'Easy'},
      {'name': 'Karachi Haleem (Special Chicken)', 'cat': 'Chicken', 'tags': 'Haleem,Chicken,Lentils,Wheat', 'time': '55', 'diff': 'Hard'},
      {'name': 'Peshawari Dum Pukht Mutton', 'cat': 'Lamb', 'tags': 'DumPukht,Peshawar,Mutton,SlowCook,Fragrant', 'time': '60', 'diff': 'Hard'},
      {'name': 'Balochi Raan Roast', 'cat': 'Lamb', 'tags': 'Raan,Balochi,Roast,MuttonLeg,Feast', 'time': '60', 'diff': 'Hard'},
      {'name': 'Lahori Katakat (Tawa Special)', 'cat': 'Beef', 'tags': 'Katakat,Tawa,Lahore,StreetFood,Spicy', 'time': '20', 'diff': 'Easy'},
      {'name': 'Karachi Burns Road Beef Nihari', 'cat': 'Beef', 'tags': 'Nihari,BurnsRoad,Karachi,Nalli,Spicy', 'time': '60', 'diff': 'Hard'},
      {'name': 'Memoni Mutton Akni', 'cat': 'Lamb', 'tags': 'Akni,Memoni,Rice,Mutton,Biryani', 'time': '45', 'diff': 'Medium'},
      {'name': 'Multani Sohan Halwa', 'cat': 'Dessert', 'tags': 'SohanHalwa,Multan,Sweet,DesiGhee,Nuts', 'time': '35', 'diff': 'Medium'},
      {'name': 'Peshawari Namkeen Gosht', 'cat': 'Lamb', 'tags': 'NamkeenGosht,Peshawar,Meat,Khyber,Simple', 'time': '40', 'diff': 'Easy'},
      {'name': 'Chicken Tawa Boti Masala', 'cat': 'Chicken', 'tags': 'TawaBoti,Chicken,Spicy,StreetFood', 'time': '20', 'diff': 'Easy'},
      {'name': 'Desi Murgh Shinwari Karahi', 'cat': 'Chicken', 'tags': 'DesiMurgh,Shinwari,Karahi,Pure', 'time': '35', 'diff': 'Medium'},
      {'name': 'Lahori Dahi Bhallay (Meethi Chutney)', 'cat': 'Breakfast', 'tags': 'DahiBhallay,Lahore,Chaat,StreetFood', 'time': '15', 'diff': 'Easy'},
      {'name': 'Koyla Dum Biryani (Smoky)', 'cat': 'Chicken', 'tags': 'KoylaBiryani,Smoky,Dum,Chicken,Rice', 'time': '45', 'diff': 'Medium'},
      {'name': 'Sindhi Kadhi Chawal', 'cat': 'Vegetarian', 'tags': 'SindhiKadhi,Vegetarian,Tamarind,Rice', 'time': '30', 'diff': 'Easy'},
      {'name': 'Hyderabadi Mirchi Ka Salan', 'cat': 'Vegetarian', 'tags': 'MirchiSalan,Side,Biryani,Curry', 'time': '25', 'diff': 'Easy'},
      {'name': 'Bihari Beef Boti Paratha Roll', 'cat': 'Beef', 'tags': 'Roll,BihariRoll,StreetFood,Karachi', 'time': '20', 'diff': 'Easy'},
      {'name': 'Chicken Malai Tikka Paratha Roll', 'cat': 'Chicken', 'tags': 'Roll,MalaiRoll,Chicken,StreetFood', 'time': '20', 'diff': 'Easy'},
      {'name': 'Koyla Seekh Kabab Paratha Roll', 'cat': 'Beef', 'tags': 'Roll,SeekhRoll,BBQ,StreetFood', 'time': '20', 'diff': 'Easy'},
      {'name': 'Garlic Naan with Desi Butter', 'cat': 'Breakfast', 'tags': 'GarlicNaan,Tandoor,Bread,Butter', 'time': '15', 'diff': 'Easy'},
      {'name': 'Roghani Naan Desi Ghee', 'cat': 'Breakfast', 'tags': 'RoghaniNaan,Sesame,DesiGhee,Bread', 'time': '15', 'diff': 'Easy'},
      {'name': 'Mutton Paya Shorba Special', 'cat': 'Lamb', 'tags': 'Paya,Shorba,Breakfast,Winter,Mutton', 'time': '60', 'diff': 'Hard'},
    ];



    int counter = 155;
    for (final item in additionalDishNames) {
      final id = 'pak_$counter';
      final name = item['name'] as String;
      final cat = item['cat'] as String;
      final tags = item['tags'] as String;
      final time = item['time'] as String;
      final diff = item['diff'] as String;

      String sampleImg = 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=800&auto=format&fit=crop';
      if (cat == 'Chicken' || cat == 'Lamb' || cat == 'Beef') {
        sampleImg = 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=800&auto=format&fit=crop';
      } else if (cat == 'Dessert') {
        sampleImg = 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=800&auto=format&fit=crop';
      } else if (cat == 'Seafood') {
        sampleImg = 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?q=80&w=800&auto=format&fit=crop';
      } else if (cat == 'Breakfast') {
        sampleImg = 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?q=80&w=800&auto=format&fit=crop';
      }

      addRecipe(
        id: id,
        name: name,
        category: cat,
        image: sampleImg,
        tags: tags,
        difficulty: diff,
        prepTime: time,
        rating: '4.8',
        reviews: '${(counter * 17) % 900 + 400}',
        steps: [
          'Prepare fresh ingredients and authentic Pakistani whole spices.',
          'Sauté aromatic onions, ginger-garlic paste, and tomatoes in desi ghee/oil.',
          'Add main ingredient ($name) with ground spices and simmer on medium flame.',
          'Stir-fry (bhunai) until oil separates and rich aroma fills the kitchen.',
          'Garnish with fresh green chillies, ginger slivers, and coriander; serve steaming hot.'
        ],
        ingredients: [
          {'name': 'Main $name Base Ingredients', 'measure': '750g'},
          {'name': 'Desi Ghee / Cooking Oil', 'measure': '1/2 cup'},
          {'name': 'Authentic Spices & Ginger-Garlic', 'measure': '2.5 tbsp'},
          {'name': 'Fresh Tomatoes & Green Chillies', 'measure': 'Generous amount'},
          {'name': 'Fresh Coriander & Herbs', 'measure': 'For Garnish'},
        ],
      );
      counter++;
    }

    return list;
  }

  static List<RecipeModel> getRecipeModels() {
    return rawPakistaniRecipes.map((json) => RecipeModel.fromJson(json)).toList();
  }

  static Recipe? getRecipeDetailById(String id) {
    final cleanId = id.trim();
    final match = rawPakistaniRecipes.firstWhere(
      (item) => item['idMeal'] == cleanId,
      orElse: () => {},
    );
    if (match.isEmpty) return null;
    return Recipe.fromJson(match);
  }
}
