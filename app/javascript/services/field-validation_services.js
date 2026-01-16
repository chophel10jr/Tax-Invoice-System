export const validTransactionReferenceNumber = (transactionReferenceNumber) => { 
  return typeof transactionReferenceNumber === "string" &&
         transactionReferenceNumber.trim().length === 16;
};

export const validAmount = (amount) => { 
  return amount > 0;
};

export const validCID = (cid) => { 
  const cidPattern = /^\d{11}$/;
  return cidPattern.test(cid.trim());
};

export const validEmail = (email) => { 
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailPattern.test(email.trim());
};

export const validPhone = (phone) => { 
  const contactNumberPattern = /^(77|17|16)\d{6}$/;
  return contactNumberPattern.test(phone);
};

export const validMandatory = (value) => {
  return value.trim() !== "";
};
