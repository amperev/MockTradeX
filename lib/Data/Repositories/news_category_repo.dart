import '../Models/newsCategory.dart';

List<CategoryModel> getCategories(){

  List<CategoryModel> category =[];
  CategoryModel categoryModel =new CategoryModel();


  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Crypto";
  categoryModel.imagePath = "assets/bitcoin_tile.jpg";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Bitcoin";
  categoryModel.imagePath = "assets/bitcoin_tile.jpg";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Ethereum";
  categoryModel.imagePath = "assets/ethereum_tile.jpg";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryName = "BlockChain";
  categoryModel.imagePath = "assets/block_chain_tile1.jpg";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Metaverse";
  categoryModel.imagePath = "assets/metaverse_tile.jpg";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryName = "NFT";
  categoryModel.imagePath = "assets/nft_tile.jpg";
  category.add(categoryModel);




  return category;
}