# NFT Marketplace

A full-stack decentralized NFT Marketplace built using Next.js, React, Solidity, and Web3 technologies.

## Features

* Create and upload NFTs
* Connect crypto wallets
* NFT detail pages
* Author and collection pages
* Search NFTs
* Trending creators section
* Audio and video NFT support
* Responsive modern UI
* Smart contract integration

## Tech Stack

* Next.js
* React.js
* Solidity
* Web3.js
* Ethers.js
* Hardhat
* Styled Components
* IPFS
* MetaMask

## Project Structure

```bash
NFT-MARKETPLACE/
│
├── components/
├── contracts/
├── pages/
├── public/
├── styles/
├── Context/
├── UploadNFT/
├── NFTDetailsPage/
├── collectionPage/
├── authorPage/
└── scripts/
```

## Installation

Clone the repository:

```bash
git clone https://github.com/J-satvik/Password-Manager.git 
```

Move into the project directory:

```bash
cd NFT-MARKETPLACE
```

Install dependencies:

```bash
npm install
```

Run the development server:

```bash
npm run dev
```

Open in browser:

```bash
http://localhost:3000
```

## Smart Contracts

Compile contracts:

```bash
npx hardhat compile
```

Deploy contracts:

```bash
npx hardhat run scripts/deploy.js --network localhost
```

## Environment Variables

Create a `.env.local` file and add:

```env
NEXT_PUBLIC_RPC_URL=
NEXT_PUBLIC_CHAIN_ID=
NEXT_PUBLIC_CONTRACT_ADDRESS=
PRIVATE_KEY=
```



## Future Improvements

* NFT auctions
* Lazy minting
* Multi-chain support
* User profiles
* NFT analytics dashboard

## License

This project is for educational purposes only.
