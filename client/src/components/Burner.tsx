import { useDojo } from '../DojoContext';

function Burner() {
  const {
    account: { create, list, select, account, isDeploying }
  } = useDojo();

  return (
    <>
      <button onClick={create}>{isDeploying ? "deploying burner" : "create burner"}</button>
      <div className="card">
        select signer:{" "}
        <select onChange={e => select(e.target.value)}>
          {list().map((account, index) => {
            return <option value={account.address} key={index}>{account.address}</option>
          })}
        </select>
        <p>
          account: {account.address}
        </p>
      </div>
    </>
  );
}

export default Burner;
