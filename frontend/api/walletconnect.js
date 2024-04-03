import { useState } from 'react';
import { SuiWalletProvider, useSuiWallet } from '@mysten/wallet-adapter-react';

const ConnectWalletButton = () => {
  const [isWalletConnected, setIsWalletConnected] = useState(false);
  const { connectWallet } = useSuiWallet();

  const handleConnectWallet = async () => {
    const wallet = await connectWallet();

    if (wallet) {
      setIsWalletConnected(true);
    }
  };

  return (
    <button onClick={handleConnectWallet}>
      {isWalletConnected ? 'Disconnect Wallet' : 'Connect Wallet'}
    </button>
  );
};

const App = () => {
  return (
    <SuiWalletProvider>
      <ConnectWalletButton />
    </SuiWalletProvider>
  );
};
