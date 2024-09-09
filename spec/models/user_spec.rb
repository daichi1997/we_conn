require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    context '新規登録できる場合' do
      it '正しい情報で登録できる' do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context '新規登録できない場合' do
      it 'nicknameが空では登録できない' do
        user = build(:user, name: '')
        user.valid?
        expect(user.errors.full_messages).to include("Nameを入力してください")
      end

      it 'emailが空では登録できない' do
        user = build(:user, email: '')
        user.valid?
        expect(user.errors.full_messages).to include("Eメールを入力してください")
      end

      it 'emailが重複すると登録できない' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        user.valid?
        expect(user.errors.full_messages).to include("Eメールはすでに存在します")
      end

      it 'emailは@を含まないと登録できない' do
        user = build(:user, email: 'testexample.com')
        user.valid?
        expect(user.errors.full_messages).to include("Eメールは不正な値です")
      end

      it 'passwordが空では登録できない' do
        user = build(:user, password: '')
        user.valid?
        expect(user.errors.full_messages).to include("パスワードを入力してください")
      end

      it 'passwordは5文字以下では登録できない' do
        user = build(:user, password: '12345', password_confirmation: '12345')
        user.valid?
        expect(user.errors.full_messages).to include("パスワードは6文字以上で入力してください")
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        user = build(:user, password: '123456', password_confirmation: '1234567')
        user.valid?
        expect(user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it 'nicknameが2文字未満では登録できない' do
        user = build(:user, name: 'a')
        user.valid?
        expect(user.errors.full_messages).to include("Nameは2文字以上で入力してください")
      end

      it 'nicknameが10文字を超えると登録できない' do
        user = build(:user, name: 'a' * 11)
        user.valid?
        expect(user.errors.full_messages).to include("Nameは10文字以内で入力してください")
      end

      it 'passwordが半角英数字以外を含むと登録できない' do
        user = build(:user, password: 'pass word123', password_confirmation: 'pass word123')
        user.valid?
        expect(user.errors.full_messages).to include("パスワードは不正な値です")
      end
    end
  end
end